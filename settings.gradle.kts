rootProject.name = "dagpenger"

include(
    "events",
    "streams"
)

pluginManagement {
    repositories {
        gradlePluginPortal()
        jcenter()
        maven(url = "https://dl.bintray.com/gradle/gradle-plugins")
    }
}
