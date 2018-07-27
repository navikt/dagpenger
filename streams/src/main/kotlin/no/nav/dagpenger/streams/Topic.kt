package no.nav.dagpenger.streams

import org.apache.kafka.common.serialization.Serde

data class Topic<K, V>(
    val name: String,
    val keySerde: Serde<K>,
    val valueSerde: Serde<V>
)