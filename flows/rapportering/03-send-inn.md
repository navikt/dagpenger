# Flyt: Send inn rapporteringsperiode (meldekort)

## Beskrivelse
Denne flyten beskriver prosessen fra brukeren sender inn en utfylt rapporteringsperiode til den er journalført og behandlet for utbetaling.

## Frontend til BFF

### 1. Frontend: dp-rapportering-frontend
**Trigger:** Bruker fyller ut og sender inn rapporteringsperiode

**URL:** `/periode/{rapporteringsperiodeId}/send-inn` (React Router route)

**Fil:** `dp-rapportering-frontend/app/routes/periode.$rapporteringsperiodeId.send-inn.tsx`

**API-kall:**
- `POST /rapporteringsperiode`
  - Request body: Rapporteringsperiode JSON (med dager og aktiviteter)
  - Repository: `dp-rapportering`

### 2. BFF: dp-rapportering
**Route:** `POST /rapporteringsperiode`

**Fil:** `dp-rapportering/src/main/kotlin/no/nav/dagpenger/rapportering/api/RapporteringApi.kt`

**Prosessering:**
1. Henter brukerens ident fra token
2. Validerer rapporteringsperiode
3. Kaller `rapporteringService.sendRapporteringsperiode()`
4. Sender til Arena eller dp-meldekortregister (baksystem)
5. Lagrer i lokal database
6. Publiserer events

**Database:**
- Tabell: `rapporteringsperiode`
- Status: `Innsendt`
- Database: `dp-rapportering` PostgreSQL

**External API calls:**
- `dp-arena-meldeplikt-adapter` eller `dp-meldekortregister` (baksystem)
  - Sender rapporteringsdata for prosessering

**Response:**
- Status: `200 OK` (ved suksess)
- Status: `400 Bad Request` (ved valideringsfeil)
- Body: `InnsendingResponse` med status

## Event-flyt

### 3. Behov: Journalføring
**Produsert av:** `dp-rapportering` (RapporteringService)

**Event:** `behov` med `@behov: ["JournalførRapportering"]`

**Innhold:**
- `rapporteringsperiodeId` - ID for perioden
- `ident` - Brukerens fødselsnummer
- `rapporteringsdata` - Strukturert data om perioden

### 4. Journalføring
**Service:** `dp-behov-journalforing` (eller tilsvarende)

**Prosess:**
1. Konsumerer behov for journalføring
2. Genererer PDF av rapporteringsperioden
3. Journalfører til Joark
4. Publiserer `rapportering_journalført` event

**External API calls:**
- `POST /dokarkiv/v1/journalpost` (Joark API)

### 5. Tilbake til dp-rapportering
**Event konsumert:** `rapportering_journalført`

**Fil:** `dp-rapportering/src/main/kotlin/no/nav/dagpenger/rapportering/tjenester/RapporteringJournalførtMottak.kt`

**Prosess:**
1. Mottar journalpostId
2. Oppdaterer rapporteringsperiode med journalpost-referanse
3. Markerer som journalført

**Database oppdatering:**
- Tabell: `rapporteringsperiode`
- Status: `Journalført`
- Lagrer journalpostId

## Behandling og utbetaling

### 6. dp-behandling konsumerer
**Event konsumert:** `beregn_meldekort`

**Fil:** `dp-behandling/mediator/src/main/kotlin/no/nav/dagpenger/behandling/mediator/mottak/BeregnMeldekortMottak.kt`

**Prosess:**
1. Henter eksisterende behandling for bruker
2. Beregner utbetaling basert på rapporterte dager
3. Oppdaterer behandling med meldekortdata
4. Sender til utbetaling

**Database:**
- Tabell: `behandling` (oppdatert)
- Tabell: `meldekort` (ny rad)
- Database: `dp-behandling` PostgreSQL

**Events produsert:**
- `meldekort_beregnet` - Beregning fullført
- Behov for utbetaling (til dp-iverksett eller dp-oppdrag)

## Mermaid diagram

\`\`\`mermaid
sequenceDiagram
    participant User as Bruker
    participant FE as dp-rapportering-frontend
    participant API as dp-rapportering API
    participant DB1 as dp-rapportering DB
    participant Arena as Arena/Meldekortregister
    participant Rapid as Kafka Rapid
    participant Journal as dp-behov-journalforing
    participant Joark as Joark API
    participant Behandling as dp-behandling
    participant BehDB as dp-behandling DB
    participant Utbetaling as dp-iverksett

    User->>FE: Fyller ut aktiviteter
    User->>FE: Klikk "Send inn"
    FE->>API: POST /rapporteringsperiode
    API->>API: Valider periode
    API->>DB1: Lagre rapportering
    API->>Arena: Send til baksystem
    Arena-->>API: OK/Feil
    API->>FE: 200 OK (InnsendingResponse)
    FE->>User: Vis bekreftelse

    API->>Rapid: Publiser behov [JournalførRapportering]
    
    Rapid->>Journal: Motta behov
    Journal->>Journal: Generer PDF
    Journal->>Joark: POST /journalpost
    Joark-->>Journal: journalpostId
    Journal->>Rapid: Publiser rapportering_journalført
    
    Rapid->>API: Motta rapportering_journalført
    API->>DB1: Oppdater med journalpostId
    
    Rapid->>Behandling: Motta beregn_meldekort
    Behandling->>BehDB: Hent behandling
    Behandling->>Behandling: Beregn utbetaling
    Behandling->>BehDB: Lagre meldekort
    Behandling->>Rapid: Publiser meldekort_beregnet
    
    Rapid->>Utbetaling: Send til utbetaling
    Utbetaling->>Utbetaling: Iverksett utbetaling
\`\`\`

## Nøkkelinformasjon

### API Endpoints
- `POST /rapporteringsperiode` - Send inn periode
- `GET /rapporteringsperioder` - Hent ikke-innsendte perioder
- `GET /rapporteringsperioder/innsendte` - Hent tidligere innsendte
- `POST /rapporteringsperiode/{id}/start` - Start utfylling

### Events produsert
- `behov` med `@behov: ["JournalførRapportering"]` - Trigger journalføring
- `rapportering_innsendt` - Innsendt til baksystem
- `rapportering_journalført` - Journalføring fullført

### Events konsumert
- `beregn_meldekort` - dp-behandling beregner utbetaling
- `rapportering_journalført` - Mottar journalpostId

### Databaser
- `dp-rapportering` PostgreSQL
  - `rapporteringsperiode` - Rapporteringsperioder
    - `id` (PK)
    - `ident`
    - `periode_fra` / `periode_til`
    - `dager` (JSONB)
    - `status` (Innsendt, Journalført, etc.)
    - `journalpost_id`
- `dp-behandling` PostgreSQL
  - `meldekort` - Meldekortdata
  - `behandling` - Oppdatert med meldekortinfo

### Eksterne API-kall
- Arena/Meldekortregister: Send rapporteringsdata
- Joark: `POST /dokarkiv/v1/journalpost`

### Validering
- Alle dager må være fylt ut
- Aktiviteter må være gyldige
- Periode må være klar for innsending
- Bruker må ha meldeplikt
