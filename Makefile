SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

sync: meta-update sync-template
.PHONY: sync

clean:
	rm -rf node_modules
	rm -rf tmp
.PHONY: clean

# Disabled until I find a way to actually use nvm from Make
#tmp/.has-nvm.sentinel:
#	[ -s "/usr/local/opt/nvm/nvm.sh" ] || brew install nvm
#	mkdir -p $(@D) && touch $@
#
#tmp/.nvm-set.sentinel: .nvmrc tmp/.has-nvm.sentinel
#	nvm install
#	mkdir -p $(@D) && touch $@

tmp/.meta-installed.sentinel: .nvmrc #tmp/.nvm-set.sentinel
	npm install meta --no-save
	mkdir -p $(@D) && touch $@

meta-update: .meta tmp/.meta-installed.sentinel
	meta git update

# Files to be kept in sync with template
CODEOWNERS := $(shell ls */CODEOWNERS)
$(CODEOWNERS): .service-template/CODEOWNERS
	cp $< $@

LICENSES := $(shell ls */LICENSE.md)
$(LICENSES): .service-template/LICENSE.md
	cp $< $@

CONSTANTS := $(shell ls */buildSrc/src/main/kotlin/Constants.kt)
$(CONSTANTS): .service-template/buildSrc/src/main/kotlin/Constants.kt
	cp $< $@

BUILD_GRADLE := $(shell ls */buildSrc/build.gradle.kts)
$(BUILD_GRADLE): .service-template/buildSrc/build.gradle.kts
	cp $< $@

SETTINGS_GRADLE := $(shell ls */buildSrc/settings.gradle.kts)
$(SETTINGS_GRADLE): .service-template/buildSrc/settings.gradle.kts
	cp $< $@

BUILD_SRC := $(CONSTANTS) $(BUILD_GRADLE) $(SETTINGS_GRADLE)

sync-template: $(CODEOWNERS) $(LICENSES) $(BUILD_SRC)
