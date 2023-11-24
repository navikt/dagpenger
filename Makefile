SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
root_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

sync: meta-update sync-template
.PHONY: sync

clean:
	rm -rf node_modules
	rm -rf .repos/ .meta
.PHONY: clean

gradle-update:
	./script/update-gradle.sh

meta-update: .meta
	npx -y meta git update

mainline: ## Switch all repos to mainline (main/master)
	meta exec "$(root_dir)script/switch_to_mainline.sh"  --parallel

# Files to be kept in sync with template
CODEOWNERS := $(shell ls */CODEOWNERS)
$(CODEOWNERS): dp-service-template/CODEOWNERS
	cp $< $@

LICENSES := $(shell ls */LICENSE.md)
$(LICENSES): dp-service-template/LICENSE.md
	cp $< $@

BUILD_GRADLE := $(shell ls */buildSrc/build.gradle.kts)
$(BUILD_GRADLE): dp-service-template/buildSrc/build.gradle.kts
	cp $< $@

DEPENDABOT := $(shell ls */.github/dependabot.*)
$(DEPENDABOT): dp-service-template/.github/dependabot.yml
	cp -f $< $@

BUILD_SRC := $(BUILD_GRADLE)

sync-template: $(CODEOWNERS) $(LICENSES) $(BUILD_SRC) $(DEPENDABOT)

#
# Oppdatere repos
#
MAX_REPOS=5000
REPO_SELECTOR=^(dp|dagpenger)-.+

.repos: .repos/active .repos/archived
.PHONY: repos

.repos/all:
	mkdir -p .repos
	gh repo list navikt --limit=${MAX_REPOS} --json name,isArchived,sshUrl --jq '[.[] | select(.name | test("${REPO_SELECTOR}"))]' > $@

.repos/active: .repos/all
	cat $< | jq -rS "[.[] | select(.isArchived==false)]" > $@

.repos/archived: .repos/all
	cat $< | jq -rS "[.[] | select(.isArchived==true)]" > $@

.meta: .repos/active
	npx -y meta init
	cat .meta | jq -S --slurpfile repo $< '.projects += ([$$repo[][] | { "key": .name, "value": .sshUrl }] | from_entries)' | tee $@

slett-archived: .repos/archived
	cat $< | jq -r '.[].name' | xargs rm -rf
.PHONY: slett-archived


BUILDS.md: .repos/active
	printf "# Build dashboard\n\n\
	| Repository | Status |\n\
	| --- | --- |\n" > BUILDS.md
	find . -type f -path '*/.github/*' -name 'deploy.y*ml' | sort | awk '{split($$0,a,"/"); print "| ["a[2]"](https://github.com/navikt/"a[2]"/actions) | !["a[2]"](https://github.com/navikt/"a[2]"/actions/workflows/"a[5]"/badge.svg) |" }' | tee -a $@
