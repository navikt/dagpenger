#!/usr/bin/env bash

source $(dirname -- "$0")/java_use.sh
DEFAULT_JAVA=21
export JAVA_VERSION=$(test -f .java-version && cat .java-version || echo "$DEFAULT_JAVA")
java_use $JAVA_VERSION

if test -f build.gradle || test -f build.gradle.kts; then
  if [ -z ${GRADLEW_VERSION+x} ]; then
    echo "GRADLEW_VERSION must be set";
  else
    echo "Stashing ..."
    git stash -u
    echo "Upgrading ..."
    ./gradlew wrapper --gradle-version "$GRADLEW_VERSION" --distribution-type all
    echo "Building post-upgrade ..."
    $(dirname -- "$0")/build.sh
    echo "Committing changes ..."
    git add gradle gradlew.bat gradlew
    git commit -m"U - Upgrade Gradle wrapper to $GRADLEW_VERSION"
  fi
else
  echo "Not a gradle project."
fi