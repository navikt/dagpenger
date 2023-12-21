#/usr/bin/env bash

gh api graphql --paginate -f query='
  query($endCursor: String) {
    organization(login: "navikt") {
      team(slug: "teamdagpenger") {
        repositories(first: 10, after: $endCursor) {
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

