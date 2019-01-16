#!/usr/bin/env bash

set -eu


./gradlew wrapper --gradle-version=$GRADLE_VERSION --distribution-type=all && ./gradlew -v

for i in ./*/; do (print $i && cd $i && ./gradlew wrapper --gradle-version=$GRADLE_VERSION --distribution-type=all && ./gradlew -v | grep "Gradle"); done