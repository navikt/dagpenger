package no.nav.dagpenger.joark.ruting

class JournalpostArkivDummy : JournalpostArkiv {
    override fun utledJournalføringsBehov(journalpostId: String): String {
        return "bar"
    }
}