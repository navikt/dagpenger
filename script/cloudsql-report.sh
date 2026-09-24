#!/usr/bin/env bash
# Henter Cloud SQL-brukere, backup-konfigurasjon og (valgfritt) audit-status
# (pgaudit via `nais postgres verify-audit`) for en liste med instanser, eller
# alle instanser i gitte GCP-prosjekter, og skriver en markdown-rapport.
#
# Bruk:
#   ./cloudsql-report.sh -p PROSJEKT_ID [PROSJEKT_ID2 ...] [-t TEAM]
#       # slår opp alle instanser i prosjektet/prosjektene
#
#   ./cloudsql-report.sh -i PROSJEKT:INSTANS [PROSJEKT:INSTANS2 ...] [-t TEAM]
#       # slår opp konkrete instanser
#
#   ./cloudsql-report.sh -f prosjekter.txt [-t TEAM]
#       # en prosjekt-id per linje
#
# Legg til -a APP [APP2 ...] eller -af apper.txt for å filtrere ned til
# bestemte instanser/apper uansett hvilken modus (-p/-i/-f) som brukes over.
# Filteret matcher på instansnavn (delen etter kolon i -i, eller instansnavnet
# gcloud finner via -p/-f).
#
# -t TEAM er valgfritt og slår på audit-sjekk via `nais postgres
# verify-audit --team TEAM <instansnavn>`. Forutsetter at instansnavnet i
# Cloud SQL er det samme som app-navnet i Nais (standard i navikt-repoene).
# Uten -t hoppes audit-seksjonen over.
#
# Krav:
#   - `gcloud` CLI, autentisert, med minst `cloudsql.instances.list`,
#     `cloudsql.instances.get`, `cloudsql.users.list` og
#     `cloudsql.backupRuns.list` på prosjektene/instansene.
#   - `jq` for parsing av backup-konfigurasjon.
#   - `nais` CLI, autentisert, hvis -t brukes.
#
# Merk om omfang:
#   - Brukerlisten er PÅ INSTANS-nivå (delt mellom databaser i samme
#     instans), ikke per-database GRANT-rettigheter. For det siste må man
#     koble til databasen (f.eks. via Cloud SQL Auth Proxy + psql) og spørre
#     information_schema/pg_roles direkte.
#   - Backup-seksjonen viser konfigurert oppsett og de siste faktiske
#     backup-kjøringene — dekker "verifiser settings" og "verifiser at
#     backups er tatt" i backup-rutinen. Skjermdump av GCP Console må
#     fortsatt tas manuelt som vedlegg.
#   - Audit-seksjonen viser status per pgaudit-sjekk fra `nais postgres
#     verify-audit`. Verktøyets underliggende Cloud SQL-connector logger
#     tilkoblingsdetaljer (ephemeral-sertifikat, RSA-nøkkelgenerering) via
#     standard "log"-pakken; disse linjene starter med årstall (YYYY/MM/DD)
#     og filtreres bort automatisk.

set -uo pipefail

OUTPUT="cloudsql-report.md"

usage() {
  echo "Bruk: $0 (-p PROSJEKT [...] | -i PROSJEKT:INSTANS [...] | -f fil) [-a APP [...] | -af fil] [-t TEAM]" >&2
  exit 1
}

team=""
instances=()  # liste av "prosjekt:instansnavn"
app_filter=()  # liste av instansnavn å filtrere på (tom = ingen filter)
mode_set=false

discover_instances() {
  local project="$1"
  echo "==> Slår opp instanser i $project" >&2
  while IFS= read -r name; do
    [[ -n "$name" ]] && instances+=("$project:$name")
  done < <(gcloud sql instances list --project="$project" --format="value(name)" 2>/dev/null)
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p)
      mode_set=true
      shift
      while [[ $# -gt 0 && "$1" != -* ]]; do
        discover_instances "$1"
        shift
      done
      ;;
    -i)
      mode_set=true
      shift
      while [[ $# -gt 0 && "$1" != -* ]]; do
        instances+=("$1")
        shift
      done
      ;;
    -f)
      mode_set=true
      [[ -n "${2:-}" ]] || usage
      while IFS= read -r project; do
        [[ -n "$project" ]] || continue
        discover_instances "$project"
      done < "$2"
      shift 2
      ;;
    -t)
      team="$2"
      shift 2
      ;;
    -a)
      shift
      while [[ $# -gt 0 && "$1" != -* ]]; do
        app_filter+=("$1")
        shift
      done
      ;;
    -af)
      [[ -n "${2:-}" ]] || usage
      while IFS= read -r app; do
        [[ -n "$app" ]] && app_filter+=("$app")
      done < "$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done

[[ "$mode_set" == true ]] || usage

# Filtrer instanslisten på app-navn hvis -a/-af er brukt.
if [[ ${#app_filter[@]} -gt 0 ]]; then
  filtered=()
  for entry in "${instances[@]}"; do
    name="${entry#*:}"
    for wanted in "${app_filter[@]}"; do
      if [[ "$name" == "$wanted" ]]; then
        filtered+=("$entry")
        break
      fi
    done
  done
  instances=("${filtered[@]}")
fi

[[ ${#instances[@]} -gt 0 ]] || { echo "Fant ingen instanser (etter filtrering)." >&2; exit 1; }

# Fjerner naistrix-markup (<info>...</info>) fra `nais`-output.
clean_line() {
  sed -E 's#</?info>##g'
}

{
  echo "# Cloud SQL-rapport"
  echo
  echo "Generert: $(date -u +'%Y-%m-%d %H:%M UTC')"
  [[ -n "$team" ]] && echo "Team (audit-sjekk): $team"
  echo
} > "$OUTPUT"

for entry in "${instances[@]}"; do
  project="${entry%%:*}"
  instance="${entry#*:}"
  echo "==> $project / $instance" >&2

  {
    echo "## $project / $instance"
    echo
    echo "### Brukere"
    echo
    echo "| Bruker | Type |"
    echo "|--------|------|"
  } >> "$OUTPUT"

  user_rows=$(gcloud sql users list --project="$project" --instance="$instance" \
    --format="value(name,type)" 2>/dev/null || true)

  if [[ -z "$user_rows" ]]; then
    echo "| _ingen brukere funnet, eller manglende tilgang_ | |" >> "$OUTPUT"
  else
    while IFS=$'\t' read -r name type; do
      echo "| $name | $type |" >> "$OUTPUT"
    done <<< "$user_rows"
  fi

  # --- Backup-konfigurasjon ---
  {
    echo
    echo "### Backup-konfigurasjon"
    echo
    echo "| Innstilling | Verdi |"
    echo "|-------------|-------|"
  } >> "$OUTPUT"

  backup_json=$(gcloud sql instances describe "$instance" --project="$project" \
    --format="json(settings.backupConfiguration)" 2>/dev/null || true)

  if [[ -z "$backup_json" ]]; then
    echo "| _kunne ikke hente konfigurasjon, sjekk tilgang_ | |" >> "$OUTPUT"
  else
    enabled=$(echo "$backup_json" | jq -r '.settings.backupConfiguration.enabled // false')
    start_time=$(echo "$backup_json" | jq -r '.settings.backupConfiguration.startTime // "-"')
    location=$(echo "$backup_json" | jq -r '.settings.backupConfiguration.location // "-"')
    pitr=$(echo "$backup_json" | jq -r '.settings.backupConfiguration.pointInTimeRecoveryEnabled // false')
    log_retention=$(echo "$backup_json" | jq -r '.settings.backupConfiguration.transactionLogRetentionDays // "-"')
    retained_backups=$(echo "$backup_json" | jq -r '.settings.backupConfiguration.backupRetentionSettings.retainedBackups // "-"')

    {
      echo "| Automatisk backup aktivert | $enabled |"
      echo "| Starttidspunkt | $start_time |"
      echo "| Lokasjon | $location |"
      echo "| Point-in-time recovery | $pitr |"
      echo "| Transaksjonslogg-retensjon (dager) | $log_retention |"
      echo "| Antall backups som beholdes | $retained_backups |"
    } >> "$OUTPUT"
  fi

  # --- Siste faktiske backup-kjøringer ---
  {
    echo
    echo "### Siste backup-kjøringer"
    echo
    echo "| Type | Status | Starttidspunkt | Sluttidspunkt |"
    echo "|------|--------|----------------|----------------|"
  } >> "$OUTPUT"

  backup_rows=$(gcloud sql backups list --project="$project" --instance="$instance" \
    --limit=5 --format="value(type,status,startTime,endTime)" 2>/dev/null || true)

  if [[ -z "$backup_rows" ]]; then
    echo "| _ingen backups funnet, eller manglende tilgang_ | | | |" >> "$OUTPUT"
  else
    while IFS=$'\t' read -r type status start end; do
      echo "| $type | $status | $start | $end |" >> "$OUTPUT"
    done <<< "$backup_rows"
  fi

  # --- Audit-logging (valgfritt, krever -t TEAM) ---
  if [[ -n "$team" ]]; then
    {
      echo
      echo "### Audit-logging (pgaudit)"
      echo
    } >> "$OUTPUT"

    raw_output=$(nais postgres verify-audit --team "$team" "$instance" 2>&1)
    exit_code=$?

    check_lines=$(echo "$raw_output" \
      | grep -E '✅|❌' \
      | grep -vE '^[0-9]{4}/[0-9]{2}/[0-9]{2}' \
      | clean_line)

    if [[ $exit_code -eq 0 ]]; then
      echo "Status: ✅ OK" >> "$OUTPUT"
    else
      echo "Status: ❌ Feil" >> "$OUTPUT"
    fi

    {
      echo
      echo "| Sjekk |"
      echo "|-------|"
    } >> "$OUTPUT"

    if [[ -z "$check_lines" ]]; then
      echo "| _ingen sjekker returnert, se rå-output under_ |" >> "$OUTPUT"
    else
      while IFS= read -r line; do
        trimmed="$(echo "$line" | sed -E 's/^ +//')"
        echo "| $trimmed |" >> "$OUTPUT"
      done <<< "$check_lines"
    fi

    if [[ $exit_code -ne 0 ]]; then
      {
        echo
        echo "<details><summary>Rå output (feil oppstod)</summary>"
        echo
        echo '```'
        echo "$raw_output" | clean_line
        echo '```'
        echo
        echo "</details>"
      } >> "$OUTPUT"
    fi
  fi

  echo >> "$OUTPUT"
done

echo "Skrevet til $OUTPUT" >&2
