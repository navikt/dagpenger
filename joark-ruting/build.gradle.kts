plugins {
    kotlin("jvm")
    application
}

val kotlinLoggingVersion = "1.4.9"
val kafkaVersion = "1.1.1"
val confluentVersion= "4.1.2"
val avroVersion = "1.8.2"

dependencies {
    implementation(kotlin("stdlib"))
    implementation(project(":events"))
    implementation(project(":streams"))

    implementation("org.apache.kafka:kafka-clients:$kafkaVersion")
    implementation("org.apache.kafka:kafka-streams:$kafkaVersion")
    implementation("org.apache.avro:avro:$avroVersion")
    implementation("io.confluent:kafka-streams-avro-serde:$confluentVersion")

    implementation("io.github.microutils:kotlin-logging:$kotlinLoggingVersion")

    testCompile(kotlin("test"))
    testCompile(kotlin("test-junit"))
    testCompile("junit:junit:4.12")
}

application {
    version = "0.0.1"
    applicationName = "joark-ruting"
    mainClassName = "no.nav.dagpenger.joark.ruting.App"
}
