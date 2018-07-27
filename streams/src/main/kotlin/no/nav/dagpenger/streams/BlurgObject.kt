package no.nav.dagpenger.streams

import org.apache.kafka.clients.consumer.ConsumerConfig
import org.apache.kafka.streams.StreamsConfig
import org.apache.kafka.streams.errors.LogAndFailExceptionHandler
import java.util.Properties

/**
 * Not sure what this is yet. It seems like a very basic configuration holder.
 * TODO: Find a proper name as it reveals itself
 */
object BlurgObject {
    //private val log = LoggerFactory.getLogger(MicroserviceUtils::class.java)
    private val bootstrapServersConfig = System.getenv("BOOTSTRAP_SERVERS_CONFIG") ?: "localhost:9092"

    fun baseConfig(
        appId: String,
        stateDir: String? = null
    ): Properties {
        return Properties().apply {
            putAll(
                listOf(
                    StreamsConfig.BOOTSTRAP_SERVERS_CONFIG to bootstrapServersConfig,
                    StreamsConfig.APPLICATION_ID_CONFIG to appId,
                    // TODO Using processing guarantee requires replication of 3, not possible with current single node dev environment
                    //StreamsConfig.PROCESSING_GUARANTEE_CONFIG to "exactly_once",
                    StreamsConfig.COMMIT_INTERVAL_MS_CONFIG to 1,
                    ConsumerConfig.AUTO_OFFSET_RESET_CONFIG to "earliest",
                    StreamsConfig.DEFAULT_DESERIALIZATION_EXCEPTION_HANDLER_CLASS_CONFIG to LogAndFailExceptionHandler::class.java
                )
            )

            stateDir?.let { put(StreamsConfig.STATE_DIR_CONFIG, stateDir) }
        }
    }
}

fun addShutdownHookAndBlock(service: Service) {
    Thread.currentThread().setUncaughtExceptionHandler { _, _ -> service.stop() }
    Runtime.getRuntime().addShutdownHook(Thread {
        try {
            service.stop()
        } catch (ignored: Exception) {
        }
    })
    Thread.currentThread().join()
}

