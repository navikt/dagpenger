include(
    "events",
    "joark-mottak",
    "joark-ruting",
    "streams"
)

pluginManagement {
    repositories {
        gradlePluginPortal()
        jcenter()
        maven(url = "https://dl.bintray.com/gradle/gradle-plugins")
    }
}
