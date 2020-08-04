#!/usr/bin/env bash

echo Gradle version to upgrade to?
read GRADLE_VERSION

./gradlew wrapper --gradle-version=$GRADLE_VERSION --distribution-type=bin && ./gradlew -v

for i in ./*/; do (
        echo $i &&  \
        cd $i && \
        test -f ./gradlew && \
        ./gradlew wrapper \
                --gradle-version=$GRADLE_VERSION \
                --distribution-type=bin \
        && ./gradlew -v | grep "Gradle");
done