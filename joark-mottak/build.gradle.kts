import org.jetbrains.kotlin.js.config.EcmaVersion.defaultVersion

plugins {
    kotlin("jvm")
    application
}

application {
    version = "0.0.1"
    applicationName = "joark-mottak"
    mainClassName = "no.nav.dagpenger.joark.mottak.Producer"
}

val kafkaVersion = "1.1.1"
val confluentVersion= "4.1.2"
val avroVersion = "1.8.2"
var slf4jVersion = "1.7.25"

dependencies {
    implementation(kotlin("stdlib"))
    implementation(project(":events"))
    implementation(project(":streams"))

    //implementation("io.github.microutils:kotlin-logging")

    implementation("org.apache.kafka:kafka-clients:$kafkaVersion")
    implementation("org.apache.kafka:kafka-streams:$kafkaVersion")

    implementation("org.apache.avro:avro:$avroVersion")
    //implementation("io.confluent:kafka-avro-serializer:$confluentVersion")
    implementation("io.confluent:kafka-streams-avro-serde:$confluentVersion")
    //implementation("io.confluent:kafka-schema-registry-client:$confluentVersion")
    //implementation("com.commercehub.gradle.plugin:gradle-avro-plugin:+")

    //implementation("org.slf4j:slf4j-api:$slf4jVersion")
    //implementation("org.slf4j:slf4j-log4j12:$slf4jVersion")

    //runtime("org.slf4j:slf4j-api:$slf4jVersion")
    //runtime("ch.qos.logback:logback-classic:$logbackVersion")
    //runtime("net.logstash.logback:logstash-logback-encoder:$logstashVersion")

    testImplementation(kotlin("test"))
    testImplementation(kotlin("test-junit"))
    //testImplementation("junit:junit:4.12")
}
