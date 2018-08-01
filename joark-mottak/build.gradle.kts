plugins {
    kotlin("jvm")
    application
}

application {
    version = "0.0.1"
    applicationName = "joark-mottak"
    mainClassName = "no.nav.dagpenger.joark.mottak.JoarkMottak"
}

val kotlinLoggingVersion = "1.4.9"

dependencies {
    implementation(kotlin("stdlib"))
    implementation(project(":events"))
    implementation(project(":streams"))

    implementation("io.github.microutils:kotlin-logging:$kotlinLoggingVersion")

    testImplementation(kotlin("test"))
    testImplementation(kotlin("test-junit"))
    testImplementation("junit:junit:4.12")
}
