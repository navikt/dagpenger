package no.nav.dagpenger.streams.examples

import mu.KotlinLogging
import no.nav.dagpenger.streams.BlurgObject
import no.nav.dagpenger.streams.Service
import no.nav.dagpenger.streams.Topics.A_TOPIC_INSTANCE
import no.nav.dagpenger.streams.Topics.A_NEW_TOPIC_INSTANCE
import no.nav.dagpenger.streams.addShutdownHookAndBlock
import no.nav.dagpenger.streams.consumeTopic
import no.nav.dagpenger.streams.toTopic
import org.apache.kafka.streams.KafkaStreams
import org.apache.kafka.streams.StreamsBuilder

private val LOGGER = KotlinLogging.logger {}

class StreamsApp(
    private val streamService: BlurgObject
) : Service {
    private val SERVICE_APP_ID = "streams-app"
    private lateinit var streams: KafkaStreams

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val service = StreamsApp(BlurgObject)
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
        streams?.close()
    }

    fun setupStreams(): KafkaStreams {
        val builder = StreamsBuilder()
        val someStream = builder.consumeTopic(A_TOPIC_INSTANCE)

       someStream
            .peek { key, value -> LOGGER.info("Processing event with key $key and ID ${value.id}") }
            .toTopic(A_NEW_TOPIC_INSTANCE)

        return KafkaStreams(builder.build(), streamService.baseConfig(SERVICE_APP_ID))
    }
}

