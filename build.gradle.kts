plugins {
    kotlin("jvm") version "1.2.51"
    base
    id("com.diffplug.gradle.spotless") version "3.13.0"
}

allprojects {
    group = "no.nav.dagpenger"
    version = "0.0.1"
}

subprojects {
    repositories {
        jcenter()
        maven(url = "http://packages.confluent.io/maven/")
    }
}

spotless {
    kotlin {
        ktlint()
    }
    kotlinGradle {
        target("*.gradle.kts", "additionalScripts/*.gradle.kts")
        ktlint()
    }
}
