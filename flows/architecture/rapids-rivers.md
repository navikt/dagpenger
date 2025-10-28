# Rapid & Rivers Arkitektur

Dette dokumentet beskriver event-drevet arkitektur i dagpengesystemet basert på Rapid & Rivers-mønsteret.

## Konsept

Rapid & Rivers er et event-drevet arkitekturmønster utviklet i NAV for å bygge løst koblede, reaktive systemer.

### Nøkkelkomponenter

#### Rapid
**Rapid** er en Kafka-topic som fungerer som en hendelsesstrøm hvor alle meldinger publiseres.

- Alle hendelser går til samme topic
- Meldinger er JSON
- Immutable event log
- Gir full historikk

#### River
**River** er en konsument som lytter på spesifikke hendelser fra Rapid.

- Definerer hvilke meldinger den er interessert i via predikater
- Filtrerer og validerer meldinger
- Behandler kun relevante hendelser

#### Rapids Connection
Abstraksjon over Kafka som håndterer:
- Publisering av meldinger
- Konsumering av meldinger
- Serialisering/deserialisering

## Meldingestruktur

### Standard felter
Alle meldinger på Rapid har disse feltene:

\`\`\`json
{
  "@event_name": "navn_på_hendelse",
  "@id": "uuid-v4",
  "@opprettet": "2024-01-15T10:30:00.000Z",
  // ... hendelse-spesifikke data
}
\`\`\`

### Behov (Requests)
Behov er spesielle meldinger som ber om data:

\`\`\`json
{
  "@event_name": "behov",
  "@id": "uuid",
  "@opprettet": "timestamp",
  "@behov": ["Inntekt", "Arbeidsforhold"],
  "@behovId": "uuid",
  "ident": "12345678910",
  // ... context
}
\`\`\`

### Løsninger (Responses)
Tjenester som løser behov legger til løsninger:

\`\`\`json
{
  "@event_name": "behov",
  "@id": "uuid",
  "@behov": ["Inntekt"],
  "@behovId": "uuid",
  "@løsning": {
    "Inntekt": {
      "inntekter": [...],
      "beregningsdato": "2024-01-01"
    }
  },
  "@final": false
}
\`\`\`

Når alle behov er løst:
\`\`\`json
{
  "@final": true,
  "@løsning": {
    "Inntekt": {...},
    "Arbeidsforhold": {...}
  }
}
\`\`\`

## River Pattern

### Definere en River

\`\`\`kotlin
class MinMottak(
    rapidsConnection: RapidsConnection
) : River.PacketListener {
    
    init {
        River(rapidsConnection).apply {
            // Preconditions - må være oppfylt
            precondition { 
                it.requireValue("@event_name", "søknad_innsendt")
            }
            
            // Validering - sjekk at felt eksisterer
            validate { 
                it.requireKey("søknadId", "ident")
                it.interestedIn("journalpostId") // Optional
            }
        }.register(this)
    }
    
    override fun onPacket(
        packet: JsonMessage,
        context: MessageContext,
        metadata: MessageMetadata,
        meterRegistry: MeterRegistry
    ) {
        val søknadId = packet["søknadId"].asText()
        // Behandle melding
    }
}
\`\`\`

### River predikater

#### requireValue
Krever at et felt har en spesifikk verdi:
\`\`\`kotlin
it.requireValue("@event_name", "søknad_innsendt")
\`\`\`

#### requireAny
Krever at et felt har en av flere verdier:
\`\`\`kotlin
it.requireAny("type", listOf("NySøknad", "Ettersending"))
\`\`\`

#### requireAll
Krever at array inneholder alle verdier:
\`\`\`kotlin
it.requireAll("@behov", listOf("Inntekt", "Arbeidsforhold"))
\`\`\`

#### requireAllOrAny
Krever at array inneholder minst en av verdiene:
\`\`\`kotlin
it.requireAllOrAny("@behov", listOf("Inntekt"))
\`\`\`

#### requireKey
Krever at felt eksisterer:
\`\`\`kotlin
it.requireKey("søknadId", "ident")
\`\`\`

#### interestedIn
Frivillig felt (ikke kræsj hvis mangler):
\`\`\`kotlin
it.interestedIn("journalpostId", "fagsakId")
\`\`\`

#### require (custom validation)
Custom validering:
\`\`\`kotlin
it.require("søknadId") { field ->
    UUID.fromString(field.asText())
}
\`\`\`

## Publisere meldinger

### Standard hendelse
\`\`\`kotlin
val message = JsonMessage.newMessage(
    eventName = "søknad_innsendt",
    map = mapOf(
        "søknadId" to søknadId,
        "ident" to ident,
        "tidspunkt" to LocalDateTime.now()
    )
)

rapidsConnection.publish(ident, message.toJson())
\`\`\`

### Behov
\`\`\`kotlin
val message = JsonMessage.newNeed(
    behov = listOf("Inntekt", "Arbeidsforhold"),
    map = mapOf(
        "ident" to ident,
        "behandlingId" to behandlingId,
        "beregningsdato" to LocalDate.now()
    )
)

rapidsConnection.publish(ident, message.toJson())
\`\`\`

### Løsning
\`\`\`kotlin
// I en behovløser
packet["@løsning"] = mapOf(
    "Inntekt" to mapOf(
        "inntekter" to inntektListe,
        "beregningsdato" to beregningsdato
    )
)

context.publish(ident, packet.toJson())
\`\`\`

## Best Practices

### 1. Idempotens
Rivers må være idempotente - kan prosessere samme melding flere ganger uten sideeffekter.

\`\`\`kotlin
override fun onPacket(packet: JsonMessage, ...) {
    val søknadId = packet["søknadId"].asUUID()
    
    // Sjekk om allerede behandlet
    if (repository.finnes(søknadId)) {
        logger.info { "Søknad $søknadId allerede behandlet" }
        return
    }
    
    // Behandle
    repository.lagre(søknadId, ...)
}
\`\`\`

### 2. Feilhåndtering
Rivers håndterer feil ved å la meldingen ligge på topic for retry.

\`\`\`kotlin
override fun onPacket(packet: JsonMessage, ...) {
    try {
        // Behandle melding
    } catch (e: Exception) {
        logger.error(e) { "Feil ved behandling" }
        throw e // Kafka vil retrye
    }
}
\`\`\`

### 3. Logging context
Bruk structured logging:

\`\`\`kotlin
withLoggingContext(
    "søknadId" to søknadId.toString(),
    "behandlingId" to behandlingId.toString()
) {
    logger.info { "Behandler søknad" }
    // Prosesser
}
\`\`\`

### 4. Metrics
Spor behandlingstid og feil:

\`\`\`kotlin
override fun onPacket(
    packet: JsonMessage,
    context: MessageContext,
    metadata: MessageMetadata,
    meterRegistry: MeterRegistry
) {
    meterRegistry.counter("soknad_mottatt").increment()
    
    try {
        // Behandle
        meterRegistry.counter("soknad_behandlet_ok").increment()
    } catch (e: Exception) {
        meterRegistry.counter("soknad_behandlet_feil").increment()
        throw e
    }
}
\`\`\`

## Event Sourcing Patterns

### Command (Behov)
En forespørsel om at noe skal skje:
- Publiseres av initiator
- Inneholder all nødvendig kontekst
- Kan ha flere løsere

### Event (Hendelse)
Noe som har skjedd:
- Publiseres når handling er ferdig
- Immutable
- Kan ha mange konsumenter

### Query (Spørring)
En forespørsel om data:
- Svares med løsning
- Asynkron
- Kan caches

## Message Flow Examples

### Eksempel 1: Søknad til behandling

\`\`\`mermaid
sequenceDiagram
    participant Soknad as dp-soknad
    participant Rapid
    participant Mottak as dp-mottak
    participant Journal as dp-behov-journalforing
    participant Behandling as dp-behandling

    Soknad->>Rapid: søknad_innsendt_varsel
    Soknad->>Rapid: behov [NyInnsending]
    
    Rapid->>Mottak: behov [NyInnsending]
    Mottak->>Rapid: behov [JournalførSøknad]
    
    Rapid->>Journal: behov [JournalførSøknad]
    Journal->>Rapid: innsending_ferdigstilt
    
    Rapid->>Soknad: innsending_ferdigstilt
    Rapid->>Behandling: innsending_ferdigstilt
    
    Behandling->>Rapid: søknad_behandlingsklar
    Behandling->>Rapid: behov [Inntekt, Arbeidsforhold, ...]
\`\`\`

### Eksempel 2: Behov med flere løsere

\`\`\`mermaid
sequenceDiagram
    participant Behandling as dp-behandling
    participant Rapid
    participant Inntekt as dp-inntekt
    participant Arena as dp-arena-trakt
    participant PDL

    Behandling->>Rapid: behov [Inntekt, ArenaData, Person]
    
    Rapid->>Inntekt: behov (Inntekt ikke løst)
    Inntekt->>Rapid: løsning (Inntekt)
    
    Rapid->>Arena: behov (ArenaData ikke løst)
    Arena->>Rapid: løsning (ArenaData)
    
    Rapid->>PDL: behov (Person ikke løst)
    PDL->>Rapid: løsning (Person), @final=true
    
    Rapid->>Behandling: behov (@final=true)
\`\`\`

## Fordeler med Rapid & Rivers

### Løs kobling
- Tjenester kjenner ikke til hverandre
- Lett å legge til nye konsumenter
- Lett å fjerne tjenester

### Skalerbarhet
- Hver tjeneste kan skalere uavhengig
- Kafka håndterer load balancing
- Parallell prosessering

### Resiliens
- Automatisk retry ved feil
- Ingen single point of failure
- Event log gir full historikk

### Observabilitet
- All kommunikasjon går via Rapid
- Lett å trace meldingsflyt
- Metrics og logging på ett sted

## Utfordringer

### Kompleksitet
- Distribuert system er komplekst
- Vanskelig å debugge flows
- Mange komponenter å forstå

### Eventual consistency
- Data er ikke umiddelbart konsistent
- Må håndtere forsinkelser
- Race conditions

### Testing
- Vanskelig å teste hele flyten
- Må mocke Rapid i tester
- End-to-end testing er viktig

## Testing

### Unit test med mock Rapid

\`\`\`kotlin
@Test
fun `skal behandle søknad innsendt`() {
    val rapid = TestRapid()
    val mottak = SøknadInnsendtMottak(rapid, mediator)
    
    rapid.sendTestMessage(
        JsonMessage.newMessage(
            "søknad_innsendt",
            mapOf("søknadId" to søknadId)
        ).toJson()
    )
    
    verify(mediator).behandle(any())
}
\`\`\`

### Contract testing
Test at meldinger har riktig struktur:

\`\`\`kotlin
@Test
fun `søknad_innsendt skal ha påkrevde felter`() {
    val message = JsonMessage.newMessage(
        "søknad_innsendt",
        mapOf("søknadId" to UUID.randomUUID())
    )
    
    assertDoesNotThrow {
        requireKey(message, "søknadId", "ident")
    }
}
\`\`\`

## Verktøy

### rapids-and-rivers bibliotek
NAVs Kotlin-bibliotek for Rapid & Rivers:
\`\`\`kotlin
dependencies {
    implementation("com.github.navikt.tbd-libs:rapids-and-rivers:VERSION")
}
\`\`\`

### Kafka UI
Verktøy for å se meldinger på Rapid:
- Kafka Manager (intern NAV)
- Kafdrop

### Monitoring
- Grafana dashboards for message rates
- Alerting på feil og forsinkelser
