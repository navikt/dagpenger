#!/bin/bash
set +x

ORG_NAME="navikt"
TEAM_NAME="teamdagpenger"

# Function to comment on a pull request
comment_on_pr() {
  local repo_name=$1
  local pr_number=$2

  gh pr comment "$pr_number" --repo "$ORG_NAME/$repo_name" --body '@dependabot rebase'
}

# Function to loop through repositories and pull requests
process_repositories() {
    response=$(gh api graphql --paginate -f query='
      query($endCursor: String) {
        organization(login: "'$ORG_NAME'") {
          team(slug: "'$TEAM_NAME'") {
            repositories(first: 10, after: $endCursor) {
              pageInfo {
                endCursor
                hasNextPage
              }
              nodes {
                name
                pullRequests(states: OPEN, labels: ["dependencies"], first: 1) {
                  nodes {
                    number
                  }
                }
              }
            }
          }
        }
      }
    ')

    # Extract data from the response
    repos=$(echo "$response" | jq -r '.data.organization.team.repositories.nodes[] | .name')
    end_cursor=$(echo "$response" | jq -r '.data.organization.team.repositories.pageInfo.endCursor')

    # Process each repository
    for repo in $repos; do
      pr_numbers=$(echo "$response" | jq -r --arg repo "$repo" '.data.organization.team.repositories.nodes[] | select(.name == $repo) | .pullRequests.nodes[] | .number')

      # Comment on each open pull request
      for pr_number in $pr_numbers; do
        comment_on_pr "$repo" "$pr_number"
      done
    done
}

# Execute the script
process_repositories
