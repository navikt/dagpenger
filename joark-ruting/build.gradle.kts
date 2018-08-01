plugins {
    kotlin("jvm")
    application
}

application {
    version = "0.0.1"
    applicationName = "joark-ruting"
    mainClassName = "no.nav.dagpenger.joark.ruting.JoarkRuting"
}

val kotlinLoggingVersion = "1.4.9"

dependencies {
    implementation(kotlin("stdlib"))
    implementation(project(":events"))
    implementation(project(":streams"))

    implementation("io.github.microutils:kotlin-logging:$kotlinLoggingVersion")

    testCompile(kotlin("test"))
    testCompile(kotlin("test-junit"))
    testCompile("junit:junit:4.12")
}
