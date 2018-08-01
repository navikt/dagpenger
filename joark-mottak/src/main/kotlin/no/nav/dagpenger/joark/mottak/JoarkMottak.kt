package no.nav.dagpenger.joark.mottak

import mu.KotlinLogging
import no.nav.dagpenger.events.avro.journalføring.InngåendeJournalpost
import no.nav.dagpenger.events.avro.journalføring.JournalTilstand
import no.nav.dagpenger.events.avro.journalføring.TynnInngåendeJournalpost
import no.nav.dagpenger.streams.Service
import no.nav.dagpenger.streams.Topics.INNGÅENDE_JOURNALPOST
import no.nav.dagpenger.streams.Topics.JOARK_EVENTS
import no.nav.dagpenger.streams.consumeTopic
import no.nav.dagpenger.streams.toTopic
import org.apache.kafka.streams.KafkaStreams
import org.apache.kafka.streams.StreamsBuilder
import java.time.LocalDate

private val LOGGER = KotlinLogging.logger {}

class JoarkMottak(
    private val journalpostArkiv: JournalpostArkiv
) : Service() {
    override val SERVICE_APP_ID = "joark-mottak"

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val service = JoarkMottak(JournalpostArkivDummy())
            service.start()
        }
    }

    override fun setupStreams(): KafkaStreams {
        println(SERVICE_APP_ID)
        val builder = StreamsBuilder()
        val inngåendeJournalposter = builder.consumeTopic(JOARK_EVENTS)

        inngåendeJournalposter
            .peek { key, value -> LOGGER.info("Processing ${value.javaClass} with key $key") }
            .mapValues(this@JoarkMottak::hentInngåendeJournalpost)
            .peek { key, value -> LOGGER.info("Producing ${value.javaClass} with key $key") }
            .toTopic(INNGÅENDE_JOURNALPOST)

        return KafkaStreams(builder.build(), this.getConfig())
    }

    private fun hentInngåendeJournalpost(inngåendeJournalpost: TynnInngåendeJournalpost): InngåendeJournalpost {
        var journalpost = journalpostArkiv.hentInngåendeJournalpost(inngåendeJournalpost.getId())

        return mapToInngåendeJournalpost(journalpost)
    }

    private fun mapToInngåendeJournalpost(journalpost: String): InngåendeJournalpost =
        InngåendeJournalpost.newBuilder().apply {
            id = "123"
            avsenderId = "abba-dabba"
            forsendelseMottatt = LocalDate.now().toString()
            tema = "DAG"
            journalTilstand = JournalTilstand.MIDLERTIDIG
            journalførendeEnhet = journalpost
        }.build()
}
