package no.nav.dagpenger.joark.ruting

import mu.KotlinLogging
import no.nav.dagpenger.events.avro.journalføring.InngåendeJournalpost
import no.nav.dagpenger.events.avro.journalføring.Journalpost
import no.nav.dagpenger.streams.BlurgObject
import no.nav.dagpenger.streams.Service
import no.nav.dagpenger.streams.Topics.INNGÅENDE_JOURNALPOST
import no.nav.dagpenger.streams.Topics.JOURNALPOST
import no.nav.dagpenger.streams.addShutdownHookAndBlock
import no.nav.dagpenger.streams.consumeTopic
import no.nav.dagpenger.streams.toTopic
import org.apache.kafka.streams.KafkaStreams
import org.apache.kafka.streams.StreamsBuilder

private val LOGGER = KotlinLogging.logger {}

class JoarkRuting(
    private val streamService: BlurgObject,
    private val journalpostArkiv: JournalpostArkiv
) : Service {
    private val SERVICE_APP_ID = "joark-ruting"
    private lateinit var streams: KafkaStreams

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val service = JoarkRuting(BlurgObject, JournalpostArkivDummy())
            service.start()
            addShutdownHookAndBlock(service)
        }
    }

    override fun start() {
        streams = setupStreams()
        streams.start()
        LOGGER.info("Started Service " + javaClass.simpleName)
    }

    override fun stop() {
        streams.close()
    }

    fun setupStreams(): KafkaStreams {
        val builder = StreamsBuilder()
        val inngåendeJournalposter = builder.consumeTopic(INNGÅENDE_JOURNALPOST)

        inngåendeJournalposter
            .peek { key, value -> LOGGER.info("Processing Journalpost with key $key and ID ${value.id}") }
            .mapValues(this@JoarkRuting::utledJournalføringsbehov)
            .mapValues(this@JoarkRuting::konverterTilJournalpost)
            .toTopic(JOURNALPOST)

        return KafkaStreams(builder.build(), streamService.baseConfig(SERVICE_APP_ID))
    }

    private fun utledJournalføringsbehov(inngåendeJournalpost: InngåendeJournalpost): InngåendeJournalpost {
        var journalføringsbehov = journalpostArkiv.utledJournalføringsBehov(inngåendeJournalpost.getId())

        return InngåendeJournalpost.newBuilder(inngåendeJournalpost).apply {
            avsenderId = journalføringsbehov
        }.build()
    }

    private fun konverterTilJournalpost(journalpost: InngåendeJournalpost): Journalpost {
        return Journalpost.newBuilder().apply {
            journalpostId = journalpost.getId()
            bruker = journalpost.getAvsenderId()
            tema = journalpost.getTema()
        }.build()
    }
}
