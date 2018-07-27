plugins {
    kotlin("jvm")
    id("java-library")
}

val kafkaVersion = "1.1.1"
val confluentVersion= "4.1.2"
val avroVersion = "1.8.2"

dependencies {
    implementation(kotlin("stdlib"))
    implementation(project(":events"))

    implementation("org.apache.kafka:kafka-clients:$kafkaVersion")
    implementation("org.apache.kafka:kafka-streams:$kafkaVersion")
    implementation("org.apache.avro:avro:$avroVersion")
    implementation("io.confluent:kafka-streams-avro-serde:$confluentVersion")

    testCompile(kotlin("test"))
    testCompile(kotlin("test-junit"))
    testCompile("junit:junit:4.12")
}
