package no.nav.dagpenger.streams

import mu.KotlinLogging
import org.apache.kafka.streams.KafkaStreams
import java.util.Properties

private val LOGGER = KotlinLogging.logger {}

abstract class Service {
    protected abstract val SERVICE_APP_ID: String

    private lateinit var streams: KafkaStreams
    fun start() {
        streams = setupStreams()
        //streams.start()
        LOGGER.info("Started Service $SERVICE_APP_ID")
        addShutdownHook()
    }

    fun stop() {
        streams.close()
    }

    // Override and extend the set of properties when needed
    fun getConfig(): Properties {
        return streamConfig(SERVICE_APP_ID)
    }

    private fun addShutdownHook() {
        Thread.currentThread().setUncaughtExceptionHandler { _, _ -> stop() }
        Runtime.getRuntime().addShutdownHook(Thread {
            //try {
                stop()
            /*} catch (ignored: Exception) {
            }*/
        })
    }
    protected abstract fun setupStreams(): KafkaStreams
}