package no.nav.dagpenger.streams

import org.apache.kafka.clients.CommonClientConfigs
import org.apache.kafka.clients.consumer.ConsumerConfig
import org.apache.kafka.streams.StreamsConfig
import org.apache.kafka.streams.errors.LogAndFailExceptionHandler
import java.util.Properties

private val bootstrapServersConfig = System.getenv("BOOTSTRAP_SERVERS_CONFIG") ?: "localhost:9092"

fun streamConfig(
    appId: String,
    stateDir: String? = null
): Properties {
    return Properties().apply {
        putAll(
            listOf(
                CommonClientConfigs.RETRY_BACKOFF_MS_CONFIG to 1000,
                CommonClientConfigs.RECONNECT_BACKOFF_MS_CONFIG to 5000,
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
