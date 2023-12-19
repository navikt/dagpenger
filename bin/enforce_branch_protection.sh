#!/bin/bash

# Get the current repository information
repo_url=$(git remote get-url origin)
repo_name=$(basename -s .git "$repo_url")
owner=$(echo "$repo_url" | awk -F"(/|:)" '{print $2}')

# Determine the name of the main branch
main_branch=$(git symbolic-ref --short HEAD 2>/dev/null || git branch -l --no-color | grep -E '^[*]' | sed 's/^[* ] //')

# Configure branch protection
gh api repos/"$owner"/"$repo_name"/branches/"$main_branch"/protection \
  --method PUT \
  --silent \
  --header "Accept: application/vnd.github.v3+json" \
  --input ../.protection_settings.json

if [ $? -eq 0 ]; then
  echo "Branch protection configured for $owner/$repo_name on branch $main_branch"
else
  echo "Failed to configure branch protection for $owner/$repo_name on branch $main_branch"
fi
