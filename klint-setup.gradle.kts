repositories {
    jcenter()
}

val ktlint by configurations.creating

dependencies {
    ktlint("com.pinterest:ktlint:0.36.0")
}

val klintIdea by tasks.creating(JavaExec::class) {
    description = "Apply ktlint rules to IntelliJ"
    classpath = ktlint
    main = "com.pinterest.ktlint.Main"
    args = listOf("--apply-to-idea-project", "-y")
}
