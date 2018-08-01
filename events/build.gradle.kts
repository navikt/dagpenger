plugins {
    kotlin("jvm")
    id("java-library")
    id("com.commercehub.gradle.plugin.avro") version "0.14.2"
}

val avroVersion = "1.8.2"

dependencies {
    api("org.apache.avro:avro:$avroVersion")
}
