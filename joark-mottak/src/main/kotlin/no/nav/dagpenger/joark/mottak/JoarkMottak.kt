package no.nav.dagpenger.joark.mottak

import no.nav.dagpenger.events.journalføring.InngåendeJournalpost
import no.nav.dagpenger.events.journalføring.JournalTilstand
import no.nav.dagpenger.events.journalføring.TynnInngåendeJournalpost
import no.nav.dagpenger.streams.Service
import no.nav.dagpenger.streams.BlurgObject
import no.nav.dagpenger.streams.Topics.INNGÅENDE_JOURNALPOST
import no.nav.dagpenger.streams.Topics.JOARK_EVENTS
import no.nav.dagpenger.streams.addShutdownHookAndBlock
import no.nav.dagpenger.streams.consumeTopic
import no.nav.dagpenger.streams.toTopic
import org.apache.kafka.streams.KafkaStreams
import org.apache.kafka.streams.StreamsBuilder
import java.time.LocalDate

//private val LOGGER = KotlinLogging.logger {}

class JoarkMottak(
    private val blurg: BlurgObject,
    private val journalpostArkiv: JournalpostArkivDummy
) : Service {
    private val SERVICE_APP_ID = "joark-mottak"
    private lateinit var streams: KafkaStreams

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val service = JoarkMottak(BlurgObject, JournalpostArkivDummy())
            service.start()
            addShutdownHookAndBlock(service)
        }
    }

    override fun start() {
        streams = setupStreams()
        streams.start()
    }

    override fun stop() {
        streams?.close()
    }

    private fun setupStreams(): KafkaStreams {
        val builder = StreamsBuilder()
        val inngåendeJournalposter = builder.consumeTopic(JOARK_EVENTS)

        inngåendeJournalposter
            .peek { key, value -> println(key + value) }
            .mapValues(this@JoarkMottak::hentInngåendeJournalpost)
            .peek { key, value -> println(key + value) }
            .toTopic(INNGÅENDE_JOURNALPOST)

        return KafkaStreams(builder.build(), blurg.baseConfig(SERVICE_APP_ID))
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
