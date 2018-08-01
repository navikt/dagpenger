plugins {
    kotlin("jvm")
    id("java-library")
}

val kafkaVersion = "2.0.0"
val confluentVersion = "4.1.2"
val kotlinLoggingVersion = "1.4.9"

dependencies {
    implementation(kotlin("stdlib"))
    implementation(project(":events"))

    api("org.apache.kafka:kafka-clients:$kafkaVersion")
    api("org.apache.kafka:kafka-streams:$kafkaVersion")
    api("io.confluent:kafka-streams-avro-serde:$confluentVersion")

    implementation("io.github.microutils:kotlin-logging:$kotlinLoggingVersion")

    testCompile(kotlin("test"))
    testCompile(kotlin("test-junit"))
    testCompile("junit:junit:4.12")
}
