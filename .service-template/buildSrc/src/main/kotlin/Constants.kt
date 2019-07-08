/***
 *  Avhengigheter for Dapgenger jvm prosjekter.
 *
 *  Denne fila skal kun editeres i fra https://github.com/navikt/dagpenger monorepo. Sjekk inn ny versjon og kjør
 *  repo sync
 *
 */

// Core dependencies
object Kotlin  {
    const val version = "1.3.41"
    const val stdlib = "org.jetbrains.kotlin:kotlin-stdlib:$version"

    object Logging {
        const val version = "1.6.22"
        const val kotlinLogging = "io.github.microutils:kotlin-logging:$version"
    }
}

object Spotless {
    const val version = "3.13.0"
    const val spotless = "com.diffplug.gradle.spotless"
}

object Shadow {
    const val version = "4.0.3"
    const val shadow = "com.github.johnrengelman.shadow"
}

object Moshi {
    const val version = "1.8.0"
    const val moshi = "com.squareup.moshi:moshi:$version"
    const val moshiKotlin = "com.squareup.moshi:moshi-kotlin:$version"
    const val moshiAdapters = "com.squareup.moshi:moshi-adapters:$version"
    const val moshiKtor = "com.ryanharter.ktor:ktor-moshi:1.0.1"
}

object Dagpenger {

    object Biblioteker {
        const val version = "2019.06.26-21.20.53508650ea49"
        const val stsKlient = "com.github.navikt.dp-biblioteker:sts-klient:$version"
        const val grunnbeløp = "com.github.navikt.dp-biblioteker:grunnbelop:$version"
        const val ktorUtils = "com.github.navikt.dp-biblioteker:ktor-utils:$version"
    }

    object Streams {
        const val streams = "com.github.navikt.dagpenger-streams:2019.07.02-10.26.6b16de2e090f"
    }

    object Events {
        const val events = "com.github.navikt.dagpenger-events:2019.06.26-21.18.5669e6a90cf3"
    }
}

object Database {
    const val Postgres = "org.postgresql:postgresql:42.2.5"
    const val Kotlinquery = "com.github.seratch:kotliquery:1.3.0"
    const val Flyway = "org.flywaydb:flyway-core:6.0.0-beta2"
    const val HikariCP = "com.zaxxer:HikariCP:3.3.1"
    const val VaultJdbc = "no.nav:vault-jdbc:1.3.1"
}

object Junit5 {
    const val version = "5.4.1"
    const val api = "org.junit.jupiter:junit-jupiter-api:$version"
    const val params = "org.junit.jupiter:junit-jupiter-params:$version"
    const val engine = "org.junit.jupiter:junit-jupiter-engine:$version"
    const val vintageEngine = "org.junit.vintage:junit-vintage-engine:$version"
    const val kotlinRunner = "io.kotlintest:kotlintest-runner-junit5:3.3.0"
}

object TestContainers {
    const val version = "1.10.6"
    const val postgresql = "org.testcontainers:postgresql:$version"
}

object Wiremock {
    const val version = "2.21.0"
    const val standalone = "com.github.tomakehurst:wiremock-standalone:$version"
}

object Konfig {
    const val konfig = "com.natpryce:konfig:1.6.10.0"
}

object Mockk {
    const val version = "1.9.3"
    const val mockk = "io.mockk:mockk:$version"
}

object Fuel {
    const val version = "2.1.0"
    const val fuel = "com.github.kittinunf.fuel:fuel:$version"
    const val fuelMoshi = "com.github.kittinunf.fuel:fuel-moshi:$version"
}

object Prometheus {
    const val version = "0.6.0"
    const val common = "io.prometheus:simpleclient_common:$version"
    const val hotspot = "io.prometheus:simpleclient_hotspot:$version"
    const val log4j2 =  "io.prometheus:simpleclient_log4j2:$version"
}

object Bekk {
    const val nocommons = "no.bekk.bekkopen:nocommons:0.8.2"
}

object Kotlinx {
    const val bimap = "com.uchuhimo:kotlinx-bimap:1.2"
}

object Ktor {
    const val version = "1.2.2"
    const val server = "io.ktor:ktor-server:$version"
    const val serverNetty = "io.ktor:ktor-server-netty:$version"
    const val auth = "io.ktor:ktor-auth:$version"
    const val authJwt = "io.ktor:ktor-auth-jwt:$version"
    const val micrometerMetrics = "io.ktor:ktor-metrics-micrometer:$version"
    const val ktorTest = "io.ktor:ktor-server-test-host:$version"
}

object Micrometer {
    const val version = "1.1.5"
    const val prometheusRegistry = "io.micrometer:micrometer-registry-prometheus:$version"
}

object Ulid {
    const val version = "8.2.0"
    const val ulid = "de.huxhorn.sulky:de.huxhorn.sulky.ulid:$version"
}

object Log4j2 {
    private const val version = "2.12.0"
    const val api = "org.apache.logging.log4j:log4j-api:$version"
    const val core = "org.apache.logging.log4j:log4j-core:$version"
    const val slf4j = "org.apache.logging.log4j:log4j-slf4j-impl:$version"

    object Logstash {
        private const val version = "0.15"
        const val logstashLayout = "com.vlkan.log4j2:log4j2-logstash-layout-fatjar:$version"
    }
}

object JsonAssert {
    const val version = "1.5.0"
    const val jsonassert = "org.skyscreamer:jsonassert:$version"
}

object Klint {
    const val version = "0.31.0"
}