package no.nav.dagpenger.joark.ruting

import mu.KotlinLogging
import no.nav.dagpenger.events.avro.Journalpost
import no.nav.dagpenger.events.avro.journalføring.InngåendeJournalpost
import no.nav.dagpenger.streams.Service
import no.nav.dagpenger.streams.Topics.INNGÅENDE_JOURNALPOST
import no.nav.dagpenger.streams.Topics.JOURNALPOST
import no.nav.dagpenger.streams.consumeTopic
import no.nav.dagpenger.streams.toTopic
import org.apache.kafka.streams.KafkaStreams
import org.apache.kafka.streams.StreamsBuilder

private val LOGGER = KotlinLogging.logger {}

class JoarkRuting(
    private val journalpostArkiv: JournalpostArkiv
) : Service() {
    override val SERVICE_APP_ID = "joark-ruting"

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val service = JoarkRuting(JournalpostArkivDummy())
            service.start()
        }
    }

    override fun setupStreams(): KafkaStreams {
        LOGGER.info("Building streams for $SERVICE_APP_ID")
        val builder = StreamsBuilder()
        val inngåendeJournalposter = builder.consumeTopic(INNGÅENDE_JOURNALPOST)

        inngåendeJournalposter
            .peek { key, value: InngåendeJournalpost ->
                @Suppress("DEPRECATION")
                LOGGER.info("Processing Journalpost with key $key and ID ${value.id}")
            }
            .mapValues(this@JoarkRuting::utledJournalføringsbehov)
            .mapValues(this@JoarkRuting::konverterTilJournalpost)
            .toTopic(JOURNALPOST)

        return KafkaStreams(builder.build(), this.getConfig())
    }

    private fun utledJournalføringsbehov(inngåendeJournalpost: InngåendeJournalpost): InngåendeJournalpost {
        var journalføringsbehov = journalpostArkiv.utledJournalføringsBehov(inngåendeJournalpost.getId())

        return InngåendeJournalpost.newBuilder(inngåendeJournalpost).apply {
            avsenderId = journalføringsbehov
        }.build()
    }

    private fun konverterTilJournalpost(journalpost: InngåendeJournalpost): Journalpost {
        return Journalpost.newBuilder().apply {
            id = journalpost.getId()
            this.gsakId = journalpost.getTema()
        }.build()
    }
}
