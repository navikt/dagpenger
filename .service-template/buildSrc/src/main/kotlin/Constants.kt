/***
 *  Avhengigheter for Dapgenger jvm prosjekter.
 *
 *  Denne fila skal kun editeres i fra https://github.com/navikt/dagpenger monorepo. Sjekk inn ny versjon og kjør
 *  repo sync
 *
 */
object Avro {
    const val avro = "org.apache.avro:avro:1.9.0"
}
object Bekk {
    const val nocommons = "no.bekk.bekkopen:nocommons:0.8.2"
}

object Cucumber {
    const val version = "4.0.0"
    const val java8 = "io.cucumber:cucumber-java8:$version"
    const val junit = "io.cucumber:cucumber-junit:$version"
}

object Dagpenger {

    object Biblioteker {
        const val version = "2019.06.26-21.20.53508650ea49"
        const val stsKlient = "com.github.navikt.dp-biblioteker:sts-klient:$version"
        const val grunnbeløp = "com.github.navikt.dp-biblioteker:grunnbelop:$version"
        const val ktorUtils = "com.github.navikt.dp-biblioteker:ktor-utils:$version"
    }

    const val Streams = "com.github.navikt:dagpenger-streams:2019.07.02-10.26.6b16de2e090f"
    const val Events = "com.github.navikt:dagpenger-events:2019.06.26-21.18.5669e6a90cf3"
}

object Database {
    const val Postgres = "org.postgresql:postgresql:42.2.5"
    const val Kotlinquery = "com.github.seratch:kotliquery:1.3.0"
    const val Flyway = "org.flywaydb:flyway-core:6.0.0-beta2"
    const val HikariCP = "com.zaxxer:HikariCP:3.3.1"
    const val VaultJdbc = "no.nav:vault-jdbc:1.3.1"
}

object Fuel {
    const val version = "2.1.0"
    const val fuel = "com.github.kittinunf.fuel:fuel:$version"
    const val fuelMoshi = "com.github.kittinunf.fuel:fuel-moshi:$version"
    fun library(name: String) = "com.github.kittinunf.fuel:fuel-$name:$version"
}

object GradleWrapper {
    const val version = "5.5"
}

object Junit5 {
    const val version = "5.5.0"
    const val api = library("api")
    const val params = library("params")
    const val engine = library("engine")
    const val vintageEngine = "org.junit.vintage:junit-vintage-engine:$version"
    const val kotlinRunner = "io.kotlintest:kotlintest-runner-junit5:3.3.0"
    fun library(name: String) = "org.junit.jupiter:junit-jupiter-$name:$version"
}

object JsonAssert {
    const val version = "1.5.0"
    const val jsonassert = "org.skyscreamer:jsonassert:$version"
}

object Kafka {
    const val version = "2.2.1"
    const val clients = library("clients")
    const val streams = library("streams")
    const val streamTestUtils = library("streams-test-utils")
    fun library(name: String) = "org.apache.kafka:kafka-$name:$version"
    object Confluent {
        const val version = "5.2.1"
        const val avroStreamSerdes = "io.confluent:kafka-streams-avro-serde:$version"
    }
}

object KafkaEmbedded {
    const val env = "no.nav:kafka-embedded-env:2.0.2"
}

object Klint {
    const val version = "0.33.0"
}

object Konfig {
    const val konfig = "com.natpryce:konfig:1.6.10.0"
}

object Kotlin {
    const val version = "1.3.41"
    const val stdlib = "org.jetbrains.kotlin:kotlin-stdlib:$version"

    object Logging {
        const val version = "1.6.22"
        const val kotlinLogging = "io.github.microutils:kotlin-logging:$version"
    }
}

object Kotlinx {
    const val bimap = "com.uchuhimo:kotlinx-bimap:1.2"
}

object Ktor {
    const val version = "1.2.1"
    const val server = library("server")
    const val serverNetty = library("server-netty")
    const val auth = library("auth")
    const val authJwt = library("auth-jwt")
    const val locations = library("locations")
    const val micrometerMetrics = library("metrics-micrometer")
    const val ktorTest = library("server-test-host")
    fun library(name: String) = "io.ktor:ktor-$name:$version"
}

object Log4j2 {
    private const val version = "2.12.0"
    const val api = library("api")
    const val core = library("core")
    const val slf4j = library("slf4j-impl")

    fun library(name: String) = "org.apache.logging.log4j:log4j-$name:$version"
    object Logstash {
        private const val version = "0.15"
        const val logstashLayout = "com.vlkan.log4j2:log4j2-logstash-layout-fatjar:$version"
    }
}

object Micrometer {
    const val version = "1.1.5"
    const val prometheusRegistry = "io.micrometer:micrometer-registry-prometheus:$version"
}

object Moshi {
    const val version = "1.8.0"
    const val moshi = "com.squareup.moshi:moshi:$version"
    const val moshiKotlin = library("kotlin")
    const val moshiAdapters = library("adapters")
    const val moshiKtor = "com.ryanharter.ktor:ktor-moshi:1.0.1"
    fun library(name: String) = "com.squareup.moshi:moshi-$name:$version"
}

object Mockk {
    const val version = "1.9.3"
    const val mockk = "io.mockk:mockk:$version"
}

object Nare {
    const val version = "768ae37"
    const val nare = "no.nav:nare:$version"
}

object Prometheus {
    const val version = "0.6.0"
    const val common = library("common")
    const val hotspot = library("hotspot")
    const val log4j2 = library("log4j2")
    fun library(name: String) = "io.prometheus:simpleclient_$name:$version"
    object Nare {
        const val version = "0b41ab4"
        const val prometheus = "no.nav:nare-prometheus:$version"
    }
}

object Slf4j {
    const val version = "1.7.25"
    const val api = "org.slf4j:slf4j-api:$version"
}

object Spotless {
    const val version = "3.23.0"
    const val spotless = "com.diffplug.gradle.spotless"
}

object Shadow {
    const val version = "4.0.3"
    const val shadow = "com.github.johnrengelman.shadow"
}

object TestContainers {
    const val version = "1.10.6"
    const val postgresql = "org.testcontainers:postgresql:$version"
    const val kafka = "org.testcontainers:kafka:$version"
}

object Ulid {
    const val version = "8.2.0"
    const val ulid = "de.huxhorn.sulky:de.huxhorn.sulky.ulid:$version"
}

object Vault {
    const val javaDriver = "com.bettercloud:vault-java-driver:3.1.0"
}

object Wiremock {
    const val version = "2.21.0"
    const val standalone = "com.github.tomakehurst:wiremock-standalone:$version"
}



