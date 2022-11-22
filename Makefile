SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

sync: meta-update sync-template
.PHONY: sync

sync-deps: sync-dependencies

clean:
	rm -rf node_modules
	rm -rf .repos/ .meta
.PHONY: clean

gradle-update:
	./script/update-gradle.sh

meta-update: .meta
	npx -y meta git update

# Files to be kept in sync with template
CODEOWNERS := $(shell ls */CODEOWNERS)
$(CODEOWNERS): dp-service-template/CODEOWNERS
	cp $< $@

LICENSES := $(shell ls */LICENSE.md)
$(LICENSES): dp-service-template/LICENSE.md
	cp $< $@

REVIEWDOG := $(shell ls */.github/workflows/reviewdog.yml)
$(REVIEWDOG): dp-service-template/.github/workflows/reviewdog.yml
	cp $< $@

SNYK := $(shell ls */.github/workflows/snyk.yml)
$(SNYK): dp-service-template/.github/workflows/snyk.yml
	cp $< $@

CONSTANTS := $(shell ls */buildSrc/src/main/kotlin/Constants.kt)
$(CONSTANTS): dp-service-template/buildSrc/src/main/kotlin/Constants.kt
	cp $< $@

BUILD_GRADLE := $(shell ls */buildSrc/build.gradle.kts)
$(BUILD_GRADLE): dp-service-template/buildSrc/build.gradle.kts
	cp $< $@

SETTINGS_GRADLE := $(shell ls */buildSrc/settings.gradle.kts)
$(SETTINGS_GRADLE): dp-service-template/buildSrc/settings.gradle.kts
	cp $< $@

UAT_SCRIPT := $(shell ls */scripts/test/uatJob)
$(UAT_SCRIPT): dp-service-template/scripts/test/uatJob
	cp $< $@

BUILD_SRC := $(CONSTANTS) $(BUILD_GRADLE) $(SETTINGS_GRADLE)

sync-template: $(CODEOWNERS) $(LICENSES) $(BUILD_SRC) $(UAT_SCRIPT) $(SNYK) $(REVIEWDOG)

sync-dependencies: $(CONSTANTS)

#
# Oppdatere repos
#
MAX_REPOS=4000
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
