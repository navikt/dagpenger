#!/usr/bin/env bash
# Henter Cloud SQL-brukere for en liste med instanser, eller alle instanser
# i gitte GCP-prosjekter, og skriver en markdown-rapport.
#
# Bruk:
#   ./list-cloudsql-users.sh -p PROSJEKT_ID [PROSJEKT_ID2 ...]
#       # slår opp alle instanser i prosjektet/prosjektene
#
#   ./list-cloudsql-users.sh -i PROSJEKT:INSTANS [PROSJEKT:INSTANS2 ...]
#       # slår opp konkrete instanser
#
#   ./list-cloudsql-users.sh -f prosjekter.txt
#       # en prosjekt-id per linje
#
# Krav: `gcloud` CLI, autentisert (`gcloud auth login`) med minst
# `cloudsql.instances.list` og `cloudsql.users.list` på prosjektene/instansene.
#
# Merk: Dette lister brukere definert PÅ INSTANS-nivå (delt mellom databaser
# i samme instans), ikke per-database GRANT-rettigheter. For det siste må man
# koble til databasen (f.eks. via Cloud SQL Auth Proxy + psql) og spørre
# information_schema/pg_roles direkte.

set -euo pipefail

OUTPUT="cloudsql-users.md"

usage() {
  echo "Bruk: $0 -p PROSJEKT [PROSJEKT2 ...] | -i PROSJEKT:INSTANS [...] | -f fil" >&2
  exit 1
}

mode="${1:-}"
[[ -n "$mode" ]] || usage
shift || usage

instances=()  # liste av "prosjekt:instansnavn"

case "$mode" in
  -p)
    [[ $# -gt 0 ]] || usage
    for project in "$@"; do
      echo "==> Slår opp instanser i $project" >&2
      while IFS= read -r name; do
        [[ -n "$name" ]] && instances+=("$project:$name")
      done < <(gcloud sql instances list --project="$project" --format="value(name)" 2>/dev/null)
    done
    ;;
  -i)
    [[ $# -gt 0 ]] || usage
    instances=("$@")
    ;;
  -f)
    [[ -n "${1:-}" ]] || usage
    while IFS= read -r project; do
      [[ -n "$project" ]] || continue
      echo "==> Slår opp instanser i $project" >&2
      while IFS= read -r name; do
        [[ -n "$name" ]] && instances+=("$project:$name")
      done < <(gcloud sql instances list --project="$project" --format="value(name)" 2>/dev/null)
    done < "$1"
    ;;
  *)
    usage
    ;;
esac

[[ ${#instances[@]} -gt 0 ]] || { echo "Fant ingen instanser." >&2; exit 1; }

{
  echo "# Cloud SQL-brukere"
  echo
  echo "Generert: $(date -u +'%Y-%m-%d %H:%M UTC')"
  echo
} > "$OUTPUT"

for entry in "${instances[@]}"; do
  project="${entry%%:*}"
  instance="${entry#*:}"
  echo "==> $project / $instance" >&2

  {
    echo "## $project / $instance"
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

  echo >> "$OUTPUT"
done

echo "Skrevet til $OUTPUT" >&2
