plugins {
    base
    kotlin("jvm") version "1.2.51" apply false
    id("com.diffplug.gradle.spotless") version "3.13.0"
}

allprojects {
    group = "no.nav.dagpenger"
    version = "0.0.1"

    apply {
        plugin("com.diffplug.gradle.spotless")
    }
}

subprojects {
    repositories {
        jcenter()
        maven(url = "http://packages.confluent.io/maven/")
    }

    spotless {
        kotlin {
            ktlint()
        }
    }
}

spotless {
    kotlinGradle {
        target("*.gradle.kts", "additionalScripts/*.gradle.kts")
        ktlint()
    }
}
