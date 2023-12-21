#/usr/bin/env bash
set +x

# Set default values
TEAM="teamdagpenger"
REPO_ARG=""

# Check if a repository argument is provided
if [ $# -eq 1 ]; then
  REPO_ARG=$1
fi

gh api graphql --paginate -F team=$TEAM -F repoArg=$REPO_ARG -f  query='
  query($endCursor: String, $team: String!, $repoArg: String!) {
    organization(login: "navikt") {
      team(slug: $team) {
        repositories(first: 10, after: $endCursor, query: $repoArg) {
          pageInfo {
            endCursor
            hasNextPage
          }
          nodes {
            name
            pullRequests(states: OPEN, labels: ["dependencies"], first: 20) {
              nodes {
                number
                title
                url
              }
            }
          }
        }
      }
    }
  }
' \
--template '{{range .data.organization.team.repositories.nodes}}{{ $outerVar := .name }}{{range .pullRequests.nodes}}{{ printf "%-30s" $outerVar }} #{{.number}}: {{.title}} - {{.url}}{{"\n"}}{{end}}{{end}}'

