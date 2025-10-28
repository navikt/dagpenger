# Flyt: Start ny søknad

## Beskrivelse
Denne flyten beskriver prosessen fra brukeren starter en ny søknad til søknaden er opprettet og klar for utfylling.

## Frontend til BFF

### 1. Frontend: dp-soknadsdialog
**Trigger:** Bruker navigerer til søknadsdialog og starter ny søknad

**URL:** `/soknad` (startside)

**API-kall:**
- `POST /soknad`
  - Query params: `?spraak=NB&prosesstype=Dagpenger`
  - Repository: `dp-soknad`

### 2. BFF: dp-soknad
**Route:** `POST /soknad`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/start/StartSøknadRoute.kt`

**Prosessering:**
1. Henter brukerens ident fra token
2. Leser språk og prosesstype fra query params
3. Kaller `søknadMediator.opprettSøknadsprosess()`
4. Genererer ny søknads-UUID
5. Returnerer UUID i response body
6. Setter Location header til `{request.uri}/{søknadUuid}/fakta`

**Database:**
- Tabell: `soknad_v1` (ny rad)
- Status: `Påbegynt`
- Database: `dp-soknad` PostgreSQL

**Response:**
- Status: `201 Created`
- Header: `Location: /soknad/{uuid}/fakta`
- Body: `"{søknad-uuid}"`

## Event-flyt

### 3. Behov: NySøknad
**Produsert av:** `dp-soknad` (BehovMediator)

**Event:** `behov` med `@behov: ["NySøknad"]`

**Innhold:**
- `søknad_uuid` - UUID for søknaden
- `ident` - Brukerens fødselsnummer
- `språk` - Språkkode (NB, NN, EN)
- `prosesstype` - Type søknad (Dagpenger)

**Konsument:** `dp-quiz` (eller annen mal-tjeneste)
- Genererer søknadsmal basert på prosesstype
- Returnerer prosessversjon og mal-struktur

### 4. Søknadsmal mottak
**Event konsumert:** `behov` (med løsning for NySøknad)

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/start/SøknadOpprettetHendelseMottak.kt`

**Prosess:**
1. Venter på `@final: true` (alle behov løst)
2. Leser `@løsning.NySøknad.prosessversjon`
3. Oppretter `SøknadOpprettetHendelse`
4. Oppdaterer søknad med prosessversjon

**Database oppdatering:**
- Tabell: `soknad_v1`
- Lagrer prosessversjon
- Oppdaterer søknadsstatus

### 5. Event produsert
**Event:** `søknad_opprettet` (implisitt via tilstandsendring)

**Observer:** `SøknadTilstandObserver`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/observers/SøknadTilstandObserver.kt`

## Frontend oppfølging

### 6. Hent søkeroppgaver
**API-kall:** `GET /soknad/{uuid}/neste`
- Repository: `dp-soknad`
- Henter neste spørsmål/seksjon som skal besvares

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/påbegynt/NesteSøkerOppgaveRoute.kt`

**Response:**
- Returnerer neste faktum som skal besvares
- Eller indikerer at søknaden er komplett

## Mermaid diagram

\`\`\`mermaid
sequenceDiagram
    participant User as Bruker
    participant FE as dp-soknadsdialog
    participant API as dp-soknad API
    participant DB as dp-soknad DB
    participant Rapid as Kafka Rapid
    participant Quiz as dp-quiz

    User->>FE: Klikk "Start søknad"
    FE->>API: POST /soknad?spraak=NB&prosesstype=Dagpenger
    API->>API: Hent ident fra token
    API->>API: Generer søknads-UUID
    API->>DB: Lagre ny søknad (Påbegynt)
    API->>Rapid: Publiser behov [NySøknad]
    API->>FE: 201 Created + UUID
    FE->>User: Redirect til /soknad/{uuid}/fakta

    Rapid->>Quiz: Motta behov [NySøknad]
    Quiz->>Quiz: Generer søknadsmal
    Quiz->>Rapid: Publiser løsning (prosessversjon)

    Rapid->>API: Motta behov-løsning (@final=true)
    API->>DB: Oppdater med prosessversjon
    API->>Rapid: Publiser søknad_opprettet (tilstand)

    FE->>API: GET /soknad/{uuid}/neste
    API->>DB: Hent neste søkeroppgave
    API->>FE: Returner neste faktum
    FE->>User: Vis første spørsmål
\`\`\`

## Nøkkelinformasjon

### API Endpoints
- `POST /soknad` - Opprett ny søknad
- `GET /soknad/{uuid}/neste` - Hent neste søkeroppgave

### Events produsert
- `behov` med `@behov: ["NySøknad"]` - Trigger malgenerering
- `søknad_opprettet` - Søknad opprettet (tilstandsendring)

### Events konsumert
- `behov` (løsning for NySøknad) - Mottar prosessversjon

### Databaser
- `dp-soknad` PostgreSQL
  - `soknad_v1` - Søknadsdata
    - `soknad_uuid` (PK)
    - `ident`
    - `prosess_versjon`
    - `tilstand` (Påbegynt)
    - `opprettet`

### Query parameters
- `spraak` - NB, NN, EN (default: NB)
- `prosesstype` - Dagpenger (default: Dagpenger)
