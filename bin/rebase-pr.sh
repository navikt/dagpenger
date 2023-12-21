#!/bin/bash
set +x

ORG_NAME="navikt"
TEAM_NAME="teamdagpenger"
REPO_QUERY=""

# Check if a repository argument is provided
if [ $# -eq 1 ]; then
  REPO_QUERY=$1
fi



# Function to comment on a pull request
comment_on_pr() {
  local repo_name=$1
  local pr_number=$2

  gh pr comment "$pr_number" --repo "$ORG_NAME/$repo_name" --body '@dependabot rebase'
}

# Function to loop through repositories and pull requests
process_repositories() {
    response=$(gh api graphql --paginate -F org=$ORG_NAME -F team=$TEAM_NAME -F repoQuery=$REPO_QUERY -f query='
      query($endCursor: String, $org: String!, $team: String!, $repoQuery: String!) {
        organization(login: $org) {
          team(slug: $team) {
            repositories(first: 10, after: $endCursor, query: $repoQuery) {
              pageInfo {
                endCursor
                hasNextPage
              }
              nodes {
                name
                pullRequests(states: OPEN, labels: ["dependencies"], first: 10) {
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
