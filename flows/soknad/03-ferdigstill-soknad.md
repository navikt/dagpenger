# Flyt: Ferdigstill og send inn søknad

## Beskrivelse
Denne flyten beskriver prosessen fra brukeren sender inn en utfylt søknad til søknaden er journalført og en behandling er opprettet.

## Frontend til BFF

### 1. Frontend: dp-soknadsdialog
**Trigger:** Bruker klikker "Send søknad" på søknadssiden

**URL:** `/soknad/[soknad_uuid]/oppsummering` (Next.js page)

**API-kall:**
- `PUT /soknad/{søknad_uuid}/ferdigstill`
  - Sender søknadstekst (JSON) i request body
  - Repository: `dp-soknad`

### 2. BFF: dp-soknad
**Route:** `PUT /soknad/{søknad_uuid}/ferdigstill`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/ferdigstilling/FerdigstillingRoute.kt`

**Prosessering:**
1. Validerer at innlogget bruker eier søknaden
2. Mottar søknadstekst (JSON med alle svar)
3. Oppretter `SøknadInnsendtHendelse`
4. Behandler hendelsen gjennom `SøknadMediator`
5. Lagrer søknadstekst i database

**Database:**
- Tabell: `soknad_v1` (oppdaterer status)
- Tabell: `soknadstekst` (lagrer JSON)
- Database: `dp-soknad` PostgreSQL

**Events produsert:**
- `søknad_innsendt_varsel` - Publiseres til Rapid
  - Inneholder: `søknadId`, `søknadstidspunkt`, `søknadData`, `ident`
  - Fil: `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/observers/SøknadInnsendtObserver.kt`

## Nedstrøms tjenester

### 3. Behov: NyInnsending
**Produsert av:** `dp-soknad` (BehovMediator)

**Event:** `behov` med `@behov: ["NyInnsending"]`

**Konsument:** `dp-mottak`
- Repository: `dp-mottak`
- Oppretter innsending for journalføring

### 4. Journalføring
**Service:** `dp-behov-journalforing`

**Prosess:**
1. Konsumerer behov for journalføring
2. Genererer PDF av søknaden (via `dp-behov-pdf-generator`)
3. Journalfører til Joark
4. Publiserer `innsending_ferdigstilt` event

**External API calls:**
- `POST /dokarkiv/v1/journalpost` (Joark API)

### 5. Tilbake til dp-soknad
**Event konsumert:** `innsending_ferdigstilt`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/innsending/tjenester/JournalførtMottak.kt`

**Prosess:**
1. Mottar journalpostId
2. Oppdaterer søknad med journalpost-referanse
3. Markerer søknad som journalført

**Database oppdatering:**
- Tabell: `soknad_v1` (status = journalført)
- Kobler journalpostId til søknad

## Behandling opprettelse

### 6. dp-behandling konsumerer
**Event konsumert:** `innsending_ferdigstilt`

**Fil:** `dp-behandling/mediator/src/main/kotlin/no/nav/dagpenger/behandling/mediator/mottak/InnsendingFerdigstiltMottak.kt`

**Prosess:**
1. Leser søknadId, ident, fagsakId, journalpostId
2. Transformerer til `søknad_behandlingsklar` event
3. Publiserer ny event

**Event produsert:** `søknad_behandlingsklar`
- Inneholder: `ident`, `søknadId`, `fagsakId`, `innsendt`, `journalpostId`, `type`

### 7. Opprett behandling
**Event konsumert:** `søknad_behandlingsklar`

**Fil:** `dp-behandling/mediator/src/main/kotlin/no/nav/dagpenger/behandling/mediator/mottak/SøknadInnsendtMottak.kt`

**Prosess:**
1. Oppretter ny behandling i database
2. Starter innhenting av opplysninger (behov)
3. Oppretter oppgave i `dp-saksbehandling`

**Database:**
- Tabell: `behandling` (ny rad)
- Tabell: `opplysning` (starter med tomme opplysninger)
- Database: `dp-behandling` PostgreSQL

**Events produsert:**
- Diverse `behov` events for innhenting av data (inntekt, arbeidsforhold, etc.)

## Mermaid diagram

\`\`\`mermaid
sequenceDiagram
    participant User as Bruker
    participant FE as dp-soknadsdialog
    participant API as dp-soknad API
    participant DB1 as dp-soknad DB
    participant Rapid as Kafka Rapid
    participant Mottak as dp-mottak
    participant Journal as dp-behov-journalforing
    participant PDF as dp-behov-pdf-generator
    participant Joark as Joark API
    participant Behandling as dp-behandling
    participant BehDB as dp-behandling DB
    participant Saksb as dp-saksbehandling

    User->>FE: Klikk "Send søknad"
    FE->>API: PUT /soknad/{uuid}/ferdigstill
    API->>API: Valider eierskap
    API->>DB1: Lagre søknadstekst
    API->>DB1: Oppdater status
    API->>Rapid: Publiser søknad_innsendt_varsel
    API->>FE: 204 No Content
    FE->>User: Vis bekreftelse

    API->>Rapid: Publiser behov [NyInnsending]
    
    Rapid->>Mottak: Motta behov
    Mottak->>Rapid: Publiser journalføring behov
    
    Rapid->>PDF: Generer PDF
    PDF->>Rapid: PDF klar
    
    Rapid->>Journal: Journalfør
    Journal->>Joark: POST /journalpost
    Joark-->>Journal: journalpostId
    Journal->>Rapid: Publiser innsending_ferdigstilt
    
    Rapid->>API: Motta innsending_ferdigstilt
    API->>DB1: Oppdater med journalpostId
    
    Rapid->>Behandling: Motta innsending_ferdigstilt
    Behandling->>Behandling: Transform til søknad_behandlingsklar
    Behandling->>Rapid: Publiser søknad_behandlingsklar
    
    Rapid->>Behandling: Motta søknad_behandlingsklar
    Behandling->>BehDB: Opprett behandling
    Behandling->>Rapid: Publiser behov for opplysninger
    Behandling->>Saksb: Opprett oppgave
\`\`\`

## Nøkkelinformasjon

### API Endpoints
- `PUT /soknad/{søknad_uuid}/ferdigstill` - dp-soknad

### Events produsert
- `søknad_innsendt_varsel` - Varsling om innsendt søknad
- `behov` med `@behov: ["NyInnsending"]` - Trigger journalføring
- `innsending_ferdigstilt` - Journalføring fullført
- `søknad_behandlingsklar` - Klar for behandling

### Events konsumert
- `innsending_ferdigstilt` - dp-soknad og dp-behandling
- `søknad_behandlingsklar` - dp-behandling

### Databaser
- `dp-soknad` PostgreSQL
  - `soknad_v1` - Søknadsdata
  - `soknadstekst` - JSON søknadstekst
- `dp-behandling` PostgreSQL
  - `behandling` - Behandlinger
  - `opplysning` - Behandlingsopplysninger

### Eksterne API-kall
- Joark: `POST /dokarkiv/v1/journalpost`
