#!/usr/bin/env bash
# Finner og (valgfritt) merger åpne "Update images digests"-PRer (digestabot)
# for alle repoer listet i .meta.
#
# Bruk:
#   bin/merge-digest-prs.sh [--refresh] [--dry-run] [--only <repo-navn>]
#
#   --refresh   Søk på nytt etter PRer og overskriv cache-filen.
#               Uten dette flagget gjenbrukes cache fra forrige kjøring
#               hvis den finnes, slik at du kan kjøre scriptet flere
#               ganger (f.eks. for å prøve --dry-run, så ekte kjøring)
#               uten å søke på nytt hver gang.
#   --dry-run   Vis hva som ville blitt gjort, ikke merge noe.
#   --only R    Begrens til ett repo-navn (uten "navikt/"-prefiks).
#   --yes, -y   Ikke spør om bekreftelse per PR, merge alle som er klare.
set +x

ORG="navikt"
TITLE="Update images digests"
CACHE_FILE="${DIGEST_PR_CACHE:-/tmp/dagpenger-digest-prs.json}"
META_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/.meta"

REFRESH=0
DRY_RUN=0
ONLY_REPO=""
ASSUME_YES=0

while [ $# -gt 0 ]; do
  case "$1" in
    --refresh) REFRESH=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --only) ONLY_REPO="$2"; shift ;;
    --yes|-y) ASSUME_YES=1 ;;
    *) echo "Ukjent flagg: $1" >&2; exit 1 ;;
  esac
  shift
done

# Ber om bekreftelse på /dev/tty (så stdin er ledig til å strømme PR-listen
# inn i while-løkken lenger ned). Returnerer 0 (ja) eller 1 (nei/avbryt).
confirm() {
  local prompt="$1"
  if [ "$ASSUME_YES" -eq 1 ] || [ "$DRY_RUN" -eq 1 ]; then
    return 0
  fi
  local reply
  read -r -p "$prompt [y/N] " reply < /dev/tty
  case "$reply" in
    y|Y|yes|ja|j) return 0 ;;
    *) return 1 ;;
  esac
}

search_prs() {
  echo "Søker etter \"$TITLE\"-PRer i repoer fra .meta ..." >&2
  local repo_args=()
  while read -r repo; do
    repo_args+=(-R "$ORG/$repo")
  done < <(jq -r '.projects | keys[]' "$META_FILE")

  gh search prs "$TITLE" "${repo_args[@]}" --state open --match title \
    --json repository,number,title,url > "$CACHE_FILE"
}

if [ "$REFRESH" -eq 1 ] || [ ! -s "$CACHE_FILE" ]; then
  search_prs
else
  echo "Bruker cachet PR-liste fra $CACHE_FILE (bruk --refresh for å søke på nytt)" >&2
fi

process_pr() {
  local repo="$1" num="$2" url="$3"

  echo "=== $repo #$num ==="
  echo "  $url"

  local info
  info=$(gh pr view "$num" --repo "$repo" \
    --json state,isDraft,mergeStateStatus,statusCheckRollup 2>&1) || {
    echo "  FEIL: kunne ikke hente PR-info: $info"
    return
  }

  local state draft mss
  state=$(echo "$info" | jq -r .state)
  draft=$(echo "$info" | jq -r .isDraft)
  mss=$(echo "$info" | jq -r .mergeStateStatus)

  if [ "$state" != "OPEN" ] || [ "$draft" = "true" ]; then
    echo "  Hopper over (state=$state draft=$draft)"
    return
  fi

  if [ "$mss" = "BEHIND" ]; then
    echo "  Branch er BEHIND, oppdaterer..."
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  (dry-run) ville kjørt: gh pr update-branch $num --repo $repo"
    else
      gh pr update-branch "$num" --repo "$repo" >/dev/null 2>&1
      sleep 8
    fi
  fi

  local failing
  failing=$(echo "$info" | jq \
    '[.statusCheckRollup[]? | select((.conclusion // .state) == "FAILURE" or (.conclusion // .state) == "ERROR")] | length')

  if [ "${failing:-0}" -gt 0 ]; then
    echo "  Hopper over: $failing feilende sjekk(er)"
    return
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  (dry-run) ville kjørt: gh pr merge $num --repo $repo --squash --admin --delete-branch"
    return
  fi

  if ! confirm "  Merge $repo #$num ($url)?"; then
    echo "  Hopper over (ikke bekreftet)"
    return
  fi

  echo "  Merger..."
  gh pr merge "$num" --repo "$repo" --squash --admin --delete-branch 2>&1 | sed 's/^/  /'
}

# PR-listen leses fra filbeskriver 3 (ikke stdin), slik at "confirm" fortsatt
# kan lese svar interaktivt fra /dev/tty inne i løkken.
while read -r repo num url <&3; do
  if [ -n "$ONLY_REPO" ] && [ "$repo" != "$ORG/$ONLY_REPO" ]; then
    continue
  fi
  process_pr "$repo" "$num" "$url"
done 3< <(jq -r --arg title "$TITLE" '.[] | select(.title == $title) | .repository.nameWithOwner + " " + (.number|tostring) + " " + .url' "$CACHE_FILE")
