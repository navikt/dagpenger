#!/usr/bin/env bash
# Henter collaborators og teams for en liste med repoer i navikt-organisasjonen
# og skriver en markdown-rapport.
#
# Bruk:
#   ./list-repo-access.sh repo1 repo2 repo3
#   ./list-repo-access.sh -f repos.txt        # en repo-navn per linje
#
# Krav: `gh` CLI, innlogget med `gh auth login` og tilgang (admin/maintain)
# på repoene som skal leses.

set -euo pipefail

ORG="navikt"
OUTPUT="repo-access.md"

usage() {
  echo "Bruk: $0 [-f repofile] [repo1 repo2 ...]" >&2
  exit 1
}

repos=()
if [[ "${1:-}" == "-f" ]]; then
  [[ -n "${2:-}" ]] || usage
  mapfile -t repos < "$2"
else
  repos=("$@")
fi

[[ ${#repos[@]} -gt 0 ]] || usage

{
  echo "# Repo-tilganger — $ORG"
  echo
  echo "Generert: $(date -u +'%Y-%m-%d %H:%M UTC')"
  echo
} > "$OUTPUT"

for repo in "${repos[@]}"; do
  echo "==> $ORG/$repo" >&2

  {
    echo "## $repo"
    echo
    echo "### Collaborators"
    echo
    echo "| Bruker | Tilgang |"
    echo "|--------|---------|"
  } >> "$OUTPUT"

  collab_rows=$(gh api "repos/$ORG/$repo/collaborators?affiliation=direct" --paginate \
    --jq '.[] | [.login, (.permissions.admin as $a | if $a then "admin" elif .permissions.maintain then "maintain" elif .permissions.push then "push" elif .permissions.triage then "triage" else "pull" end)] | @tsv' \
    2>/dev/null || true)

  if [[ -z "$collab_rows" ]]; then
    echo "| _ingen direkte collaborators_ | |" >> "$OUTPUT"
  else
    while IFS=$'\t' read -r login perm; do
      echo "| $login | $perm |" >> "$OUTPUT"
    done <<< "$collab_rows"
  fi

  {
    echo
    echo "### Teams"
    echo
    echo "| Team | Tilgang |"
    echo "|------|---------|"
  } >> "$OUTPUT"

  team_rows=$(gh api "repos/$ORG/$repo/teams" --paginate \
    --jq '.[] | [.slug, .permission] | @tsv' \
    2>/dev/null || true)

  if [[ -z "$team_rows" ]]; then
    echo "| _ingen teams_ | |" >> "$OUTPUT"
  else
    while IFS=$'\t' read -r slug perm; do
      echo "| $slug | $perm |" >> "$OUTPUT"
    done <<< "$team_rows"
  fi

  echo >> "$OUTPUT"
done

echo "Skrevet til $OUTPUT" >&2
