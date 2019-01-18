object Versions {
    const val kotlin = "1.3.11"
    const val log4j2Version = "2.11.1"
    const val kotlinLoggingVersion = "1.6.22"
    const val shadow = "4.0.3"
    const val pitest = "1.3.0"
    const val spotless = "3.13.0"
    const val kafkaVersion = "2.0.1"
    const val confluentVersion = "5.0.0"
    const val ktorVersion = "1.0.0"
    const val jupiterVersion = "5.3.2"
    const val fuelVersion = "1.15.0"
}

object Libs {

    const val kotlinLogging = "io.github.microutils:kotlin-logging:${Versions.kotlinLoggingVersion}"
    const val log4jApi = "org.apache.logging.log4j:log4j-api:${Versions.log4j2Version}"
    const val log4jCore = "org.apache.logging.log4j:log4j-core:${Versions.log4j2Version}"
    const val log4jOverSlf4j = "org.apache.logging.log4j:log4j-slf4j-impl:${Versions.log4j2Version}"
    const val logStashLogging = "com.vlkan.log4j2:log4j2-logstash-layout-fatjar:0.15"

    const val kafkaClients = "org.apache.kafka:kafka-clients:${Versions.kafkaVersion}"
    const val kafkaStreams = "org.apache.kafka:kafka-streams:${Versions.kafkaVersion}"
    const val streamSerDes = "io.confluent:kafka-streams-avro-serde:${Versions.confluentVersion}"

    const val ktorNetty = "io.ktor:ktor-server-netty:${Versions.ktorVersion}"
    const val fuel = "com.github.kittinunf.fuel:fuel:${Versions.fuelVersion}"
    const val fuelGson = "com.github.kittinunf.fuel:fuel-gson:${Versions.fuelVersion}"
}

object TestLibs {
    const val wiremock = "com.github.tomakehurst:wiremock:2.19.0"
    const val kafkaEmbedded = "no.nav:kafka-embedded-env:2.0.2"
    const val junit5Api = "org.junit.jupiter:junit-jupiter-api:${Versions.jupiterVersion}"
    const val junit5Engine = "org.junit.jupiter:junit-jupiter-engine:${Versions.jupiterVersion}"
}

object DagpengerLibs {
    const val streams = "no.nav.dagpenger:streams:0.2.5-SNAPSHOT"
    const val events = "no.nav.dagpenger:events:0.2.1-SNAPSHOT"
    const val metrics = "no.nav.dagpenger:dagpenger-metrics:0.1.0-SNAPSHOT"
}