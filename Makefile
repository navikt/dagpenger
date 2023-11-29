SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
meta_project := $(notdir $(patsubst %/,%,$(dir $(root_dir))))

.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

help:
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

init: ## Initialize a fresh clone of this repository
	@brew install jq gh -q
	@npx meta git update

meta-update: ## Add missing team-repos
	@brew install jq gh -q
	@npx meta git update
	@npx meta init --force . # Remove archived repositories
	@gh api orgs/navikt/teams/teamdagpenger/repos --paginate | jq 'map(select(.archived == false)) | .[] | "meta project import \(.name) \(.ssh_url)"' | grep -v "import dagpenger git" | grep -v "\-iac" | xargs -n 1 sh -c
	@$(MAKE) clean-gitignore
	@./bin/update_settings_gradle.sh
	@git diff --exit-code || (echo "Please commit changes " && exit 1)

pull: ## Run git pull --all --rebase --autostash on all repos
	@meta exec "$(root_dir)bin/pull_from_repo.sh" --parallel

mainline: ## Switch all repos to mainline (main/master)
	@meta exec "$(root_dir)bin/switch_to_mainline.sh"  --parallel

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

# Files to be kept in sync with template
SYNC_FILES := CODEOWNERS LICENSE.md buildSrc/build.gradle.kts .github/dependabot.yml
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

BUILDS.md: .repos/active ## Update build dashboard
	printf "# Build dashboard\n\n\
	| Repository | Status |\n\
	| --- | --- |\n" > BUILDS.md
	find . -type f -path '*/.github/*' -name 'deploy.y*ml' | sort | awk '{split($$0,a,"/"); print "| ["a[2]"](https://github.com/navikt/"a[2]"/actions) | !["a[2]"](https://github.com/navikt/"a[2]"/actions/workflows/"a[5]"/badge.svg) |" }' | tee -a $@