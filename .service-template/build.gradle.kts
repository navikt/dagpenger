import org.gradle.api.tasks.testing.logging.TestExceptionFormat
import org.gradle.api.tasks.testing.logging.TestLogEvent

plugins {
    id("application")
    kotlin("jvm") version "1.3.21"
    id("com.diffplug.gradle.spotless") version "3.13.0"
    id("info.solidsoft.pitest") version "1.3.0"
    id("com.github.johnrengelman.shadow") version "4.0.3"
}

apply {
    plugin("com.diffplug.gradle.spotless")
    plugin("info.solidsoft.pitest")
}

repositories {
    jcenter()
    maven("https://oss.sonatype.org/content/repositories/snapshots/")
    maven(url = "http://packages.confluent.io/maven/")
    maven("https://jitpack.io")
}

val gitVersion: groovy.lang.Closure<Any> by extra
version = gitVersion()
group = "no.nav.dagpenger"

application {
    applicationName = "dagpenger-SERVICENAME"
    mainClassName = "no.nav.dagpenger.SERVICENAME"
}

java {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
}

val kotlinLoggingVersion = "1.6.22"
val fuelVersion = "1.15.0"
val confluentVersion = "4.1.2"
val kafkaVersion = "2.0.0"

dependencies {
    implementation(kotlin("stdlib"))
    implementation("com.github.navikt:dagpenger-streams:2019.05.20-12.02.83ff2b7cb7f6")
    implementation("com.github.navikt:dagpenger-events:2019.05.20-11.56.33cd4c73a439")

    implementation("io.github.microutils:kotlin-logging:$kotlinLoggingVersion")
    implementation("com.github.kittinunf.fuel:fuel:$fuelVersion")
    implementation("com.github.kittinunf.fuel:fuel-gson:$fuelVersion")

    compile("org.apache.kafka:kafka-clients:$kafkaVersion")
    compile("org.apache.kafka:kafka-streams:$kafkaVersion")
    compile("io.confluent:kafka-streams-avro-serde:$confluentVersion")

    testImplementation(kotlin("test"))
    testImplementation(kotlin("test-junit"))
    testImplementation("junit:junit:4.12")
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

pitest {
    threads = 4
    pitestVersion = "1.4.3"
    coverageThreshold = 80
    avoidCallsTo = setOf("kotlin.jvm.internal")
    timestampedReports = false
}

tasks.getByName("test").finalizedBy("pitest")

tasks.withType<Test> {
    testLogging {
        showExceptions = true
        showStackTraces = true
        exceptionFormat = TestExceptionFormat.FULL
        events = setOf(TestLogEvent.PASSED, TestLogEvent.SKIPPED, TestLogEvent.FAILED)
    }
}