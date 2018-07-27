package no.nav.dagpenger.joark.mottak

interface JournalpostArkiv {
    fun hentInngåendeJournalpost(journalpostId: String): String
}
