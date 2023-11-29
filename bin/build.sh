#!/usr/bin/env bash

source $(dirname -- "$0")/java_use.sh
DEFAULT_JAVA=17
export JAVA_VERSION=$(test -f .java-version && cat .java-version || echo "$DEFAULT_JAVA")
java_use $JAVA_VERSION

test ! -f build.gradle && test ! -f build.gradle.kts || ./gradlew build --quiet