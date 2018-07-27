package no.nav.dagpenger.joark.ruting

interface JournalpostArkiv {
    fun utledJournalføringsBehov(journalpostId: String): String
}
