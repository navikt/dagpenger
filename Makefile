SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
meta_project := $(notdir $(patsubst %/,%,$(dir $(root_dir))))

# Dynamically generate phony targets from target names found in Makefile
.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

help:
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

sync: ## Update all repositories
	@brew install jq gh -q
	@npx meta git update

refresh-repos: ## Add missing team-repos
	@brew install jq gh -q
	@npx meta git update
	@npx meta init --force . # Remove archived repositories
	@gh api orgs/navikt/teams/teamdagpenger/repos --paginate | jq 'map(select(.archived == false)) | .[] | "npx meta project import \(.name) \(.ssh_url)"' | grep -v "import dagpenger git" | grep -v "\-iac" | xargs -n 1 sh -c
	@$(MAKE) clean-gitignore
	@./bin/update_settings_gradle.sh
	@git diff --exit-code || (echo "Please commit changes " && exit 1)

pull: ## Run git pull --all --rebase --autostash on all repos
	@meta exec "$(root_dir)bin/pull_from_repo.sh" --parallel

mainline: ## Switch all repos to mainline (main/master)
	@meta exec "$(root_dir)bin/switch_to_mainline.sh"  --parallel

enforce_branch_protection: ## Set up standard branch protection for all repos
	@meta exec "$(root_dir)bin/enforce_branch_protection.sh"

build: ## Run ./gradlew build
	@meta exec "$(root_dir)bin/build.sh" --exclude "dagpenger" --parallel

gw: ## Run ./gradlew <target> - (e.g run using make gw clean build)
	@meta exec "$(root_dir)bin/gw.sh $(filter-out $@,$(MAKECMDGOALS))" --exclude "$(meta_project)" --parallel

upgrade-gradle: ## Upgrade gradle in all projects - usage GRADLEW_VERSION=x.x.x make upgrade-gradle
	@meta exec "$(root_dir)bin/upgrade_gradle.sh" --exclude "$(meta_project)"
	script/upgrade_gradle.sh

check-if-up-to-date: ## check if all changes are commited and pushed - and that we are on the mainline with all changes pulled
	@meta exec "$(root_dir)bin/check_if_up_to_date.sh" --exclude "$(meta_project)" # --parallel seemed to skip some projects(?!)

list-local-commits: ## shows local, unpushed, commits
	@meta exec "git log --oneline origin/HEAD..HEAD | cat"

prepush-review: ## let's you look at local commits across all projects and decide if you want to push
	@meta exec 'output=$$(git log --oneline origin/HEAD..HEAD) ; [ -n "$$output" ] && (git show --oneline origin/HEAD..HEAD | cat && echo "Pushe? (y/N)" && read a && [ "$$a" = "y" ] && git push) || true' --exclude "$(meta_project)"

clean-gitignore: ## Remove duplicates from .gitignore
	@awk '!seen[$$0]++' .gitignore > .gitignore.tmp && mv .gitignore.tmp .gitignore

list-local-changes: ## shows local, uncommited changes
	@meta exec 'git status --porcelain' --exclude "$(meta_project)"

distribute-template: ## Distribute template to all repositories
	@meta exec --exclude "$(meta_project)" --exclude "dp-service-template" "$(root_dir)bin/distribute-template.sh $(filter-out $@,$(MAKECMDGOALS))"

# Files to be kept in sync with template
SYNC_FILES := CODEOWNERS LICENSE.md buildSrc/build.gradle.kts .github/dependabot.yaml .github/workflows/dependabot-build.yaml
REPOSITORIES := $(filter-out dp-service-template/,$(wildcard */))

sync-templates: ## Sync files with template for each repository
	@for repo in $(REPOSITORIES); do \
		if [ ! -d "$$repo/.git" ]; then \
		 	continue; \
		fi; \
		for file in $(SYNC_FILES); do \
			src="dp-service-template/$$file"; \
			dest="$$repo$$file"; \
			if [ -e "$$dest" ]; then \
				cp "$$src" "$$dest"; \
			else \
				echo "File $$dest does not exist"; \
			fi; \
		done; \
	done

BUILDS.md: .meta ## Update build dashboard
	echo "# Build dashboard" > $@
	echo "| Repository | Status |" >> $@
	echo "| --- | --- |" >> $@
	jq -r '.projects | keys[]' .meta | sort | while read repo; do \
	  if [ -f "$$repo/.github/workflows/deploy.yaml" ]; then \
	    echo "| [$$repo](https://github.com/navikt/$$repo/actions) | ![$$repo](https://github.com/navikt/$$repo/actions/workflows/deploy.yaml/badge.svg) |"; \
	  fi \
	done >> $@
