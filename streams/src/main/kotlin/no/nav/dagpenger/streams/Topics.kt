package no.nav.dagpenger.streams

import io.confluent.kafka.serializers.AbstractKafkaAvroSerDeConfig
import io.confluent.kafka.streams.serdes.avro.SpecificAvroSerde
import no.nav.dagpenger.events.Person
import no.nav.dagpenger.events.journalføring.InngåendeJournalpost
import no.nav.dagpenger.events.journalføring.Journalpost
import no.nav.dagpenger.events.journalføring.TynnInngåendeJournalpost
import org.apache.avro.specific.SpecificRecord
import org.apache.kafka.common.serialization.Serdes
import org.apache.kafka.streams.Consumed
import org.apache.kafka.streams.StreamsBuilder
import org.apache.kafka.streams.kstream.KStream
import org.apache.kafka.streams.kstream.Produced

private val serdeConfig = mapOf(
    AbstractKafkaAvroSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG to
        (System.getenv("SCHEMA_REGISTRY_URL") ?: "http://localhost:8081")
)

object Topics {
    val JOARK_EVENTS = Topic(
        "joark",
        keySerde = Serdes.String(),
        valueSerde = configureAvroSerde<TynnInngåendeJournalpost>()
    )

    val INNGÅENDE_JOURNALPOST = Topic(
        "inngaaende_journalpost",
        keySerde = Serdes.String(),
        valueSerde = configureAvroSerde<InngåendeJournalpost>()
    )

    val JOURNALPOST = Topic(
        "journalpost",
        keySerde = Serdes.String(),
        valueSerde = configureAvroSerde<Journalpost>()
    )

    val SØKNAD = Topic(
        "søknad",
        keySerde = Serdes.String(),
        valueSerde = configureAvroSerde<Person>()
    )
}

private fun <T : SpecificRecord?> configureAvroSerde(): SpecificAvroSerde<T> {
    return SpecificAvroSerde<T>().apply { configure(serdeConfig, false) }
}

fun <K : Any, V : SpecificRecord> StreamsBuilder.consumeTopic(topic: Topic<K, V>): KStream<K, V> {
    return stream<K, V>(
        topic.name, Consumed.with(topic.keySerde, topic.valueSerde)
    )
}

fun <K, V> KStream<K, V>.toTopic(topic: Topic<K, V>) {
    return to(topic.name, Produced.with(topic.keySerde, topic.valueSerde))
}

