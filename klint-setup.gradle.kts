repositories {
    jcenter()
}

val ktlint by configurations.creating

dependencies {
    ktlint("com.github.shyiko:ktlint:31.0")
}

val klintIdea by tasks.creating(JavaExec::class) {
    description = "Apply ktlint rules to IntelliJ"
    classpath = ktlint
    main = "com.github.shyiko.ktlint.Main"
    args = listOf("--apply-to-idea-project", "-y")
}
