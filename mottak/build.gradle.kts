plugins {
    kotlin("jvm")
    application
}

dependencies {
    implementation(kotlin("stdlib"))

    testCompile(kotlin("test"))
    testCompile(kotlin("test-junit"))
    testCompile("junit:junit:4.12")
}

application {
    version = "0.0.1"
    applicationName = "mottak"
    mainClassName = "no.nav.dagpenger.mottak.App"
}