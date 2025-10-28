# Flyt: Hent rapporteringsperioder

## Beskrivelse
Denne flyten beskriver hvordan en bruker henter sine rapporteringsperioder (meldekort) og starter utfylling.

## Frontend til BFF

### 1. Frontend: dp-rapportering-frontend
**Trigger:** Bruker navigerer til rapporteringsside

**URL:** `/` (root route)

**Fil:** `dp-rapportering-frontend/app/routes/_index.tsx`

**API-kall:**
- `GET /harmeldeplikt` - Sjekk om bruker har meldeplikt
- `GET /rapporteringsperioder` - Hent ikke-innsendte perioder
  - Repository: `dp-rapportering`

### 2. Sjekk meldeplikt
**Route:** `GET /harmeldeplikt`

**Fil:** `dp-rapportering/src/main/kotlin/no/nav/dagpenger/rapportering/api/RapporteringApi.kt`

**Prosessering:**
1. Henter brukerens ident fra token
2. Kaller `rapporteringService.harMeldeplikt()`
3. Sjekker mot baksystem (Arena eller dp-meldekortregister)

**External API calls:**
- `dp-arena-meldeplikt-adapter` eller `dp-meldekortregister`
  - Sjekker om bruker har aktive dagpenger og meldeplikt

**Response:**
- Status: `200 OK`
- Body: `"true"` eller `"false"` (text/plain)

### 3. Hent rapporteringsperioder
**Route:** `GET /rapporteringsperioder`

**Fil:** `dp-rapportering/src/main/kotlin/no/nav/dagpenger/rapportering/api/RapporteringApi.kt`

**Prosessering:**
1. Henter brukerens ident fra token
2. Kaller `rapporteringService.hentPerioder()`
3. Henter fra baksystem hvis ikke i lokal database
4. Returnerer liste med perioder

**Database:**
- Tabell: `rapporteringsperiode`
- Query: Hent perioder hvor status != "Innsendt"
- Database: `dp-rapportering` PostgreSQL

**External API calls:**
- `dp-arena-meldeplikt-adapter` eller `dp-meldekortregister`
  - Henter perioder fra kildesystem

**Response:**
- Status: `200 OK` - Med perioder
- Status: `204 No Content` - Ingen perioder
- Body: Array av `Rapporteringsperiode` objekter

### 4. Frontend viser perioder
**Frontend action:** Viser liste over perioder

Hver periode viser:
- Periode (fra-dato til to-dato)
- Status
- Frist for innsending
- Knapp for å starte utfylling

## Start utfylling

### 5. Start utfylling av periode
**Frontend action:** Bruker klikker "Start" på en periode

**API-kall:**
- `POST /rapporteringsperiode/{periodeId}/start`
  - Repository: `dp-rapportering`

**Route:** `POST /rapporteringsperiode/{periodeId}/start`

**Fil:** `dp-rapportering/src/main/kotlin/no/nav/dagpenger/rapportering/api/RapporteringApi.kt`

**Prosessering:**
1. Henter brukerens ident fra token
2. Kaller `rapporteringService.startUtfylling()`
3. Lagrer periode i lokal database
4. Markerer som "Under utfylling"

**Database:**
- Tabell: `rapporteringsperiode`
- Action: INSERT eller UPDATE
- Status: "Under utfylling"
- Database: `dp-rapportering` PostgreSQL

**Response:**
- Status: `200 OK`

### 6. Redirect til utfylling
**Frontend action:** Navigerer til utfyllingsskjema

**URL:** `/periode/{rapporteringsperiodeId}/fyll-ut`

**Fil:** `dp-rapportering-frontend/app/routes/periode.$rapporteringsperiodeId.fyll-ut.tsx`

## Hent spesifikk periode

### 7. Hent periode for utfylling
**API-kall:**
- `GET /rapporteringsperiode/{periodeId}`
  - Header: `Hent-Original: true` (default)
  - Repository: `dp-rapportering`

**Route:** `GET /rapporteringsperiode/{periodeId}`

**Fil:** `dp-rapportering/src/main/kotlin/no/nav/dagpenger/rapportering/api/RapporteringApi.kt`

**Prosessering:**
1. Henter brukerens ident fra token
2. Hvis `Hent-Original: true`: Henter oppdatert data fra baksystem
3. Hvis `Hent-Original: false`: Henter kun fra lokal database
4. Returnerer periode med dager og aktiviteter

**Database:**
- Tabell: `rapporteringsperiode`
- Query: SELECT WHERE id = ? AND ident = ?

**External API calls (hvis Hent-Original=true):**
- `dp-arena-meldeplikt-adapter` eller `dp-meldekortregister`
  - Henter oppdatert periodedata

**Response:**
- Status: `200 OK`
- Body: `Rapporteringsperiode` objekt
  - Inneholder dager (14 dager per periode)
  - Kan ha eksisterende aktiviteter

## Mermaid diagram

\`\`\`mermaid
sequenceDiagram
    participant User as Bruker
    participant FE as dp-rapportering-frontend
    participant API as dp-rapportering API
    participant DB as dp-rapportering DB
    participant Arena as Arena/Meldekortregister

    User->>FE: Åpne rapportering
    FE->>API: GET /harmeldeplikt
    API->>Arena: Sjekk meldeplikt
    Arena-->>API: Har meldeplikt
    API->>FE: "true"

    FE->>API: GET /rapporteringsperioder
    API->>DB: Hent perioder fra DB
    alt Ingen i database
        API->>Arena: Hent perioder fra baksystem
        Arena-->>API: Perioder
        API->>DB: Lagre perioder
    end
    API->>FE: 200 OK (Array av perioder)
    FE->>User: Vis periodeoversikt

    User->>FE: Klikk "Start" på periode
    FE->>API: POST /rapporteringsperiode/{id}/start
    API->>DB: Lagre/oppdater periode
    API->>FE: 200 OK
    FE->>User: Redirect til utfylling

    FE->>API: GET /rapporteringsperiode/{id}
    API->>Arena: Hent oppdatert data
    Arena-->>API: Periodedata
    API->>DB: Oppdater database
    API->>FE: 200 OK (Rapporteringsperiode)
    FE->>User: Vis utfyllingsskjema
\`\`\`

## Nøkkelinformasjon

### API Endpoints
- `GET /harmeldeplikt` - Sjekk om bruker har meldeplikt
- `GET /rapporteringsperioder` - Hent ikke-innsendte perioder
- `GET /rapporteringsperioder/innsendte` - Hent tidligere innsendte
- `GET /rapporteringsperiode/{id}` - Hent spesifikk periode
- `POST /rapporteringsperiode/{id}/start` - Start utfylling

### Query Parameters
Ingen

### Headers
- `Hent-Original` (Boolean, default: true) - Om data skal hentes fra baksystem

### Databaser
- `dp-rapportering` PostgreSQL
  - `rapporteringsperiode`
    - `id` (PK, BIGSERIAL)
    - `ident` (String)
    - `periode_fra` (Date)
    - `periode_til` (Date)
    - `dager` (JSONB) - Array av dager med aktiviteter
    - `status` (String) - Under utfylling, Innsendt, etc.
    - `kan_sendes` (Boolean)
    - `frist` (Date)

### Eksterne API-kall
- Arena/Meldekortregister: 
  - Sjekk meldeplikt
  - Hent rapporteringsperioder
  - Hent periodedetaljer

### Response-struktur: Rapporteringsperiode

\`\`\`json
{
  "id": 12345,
  "periode": {
    "fraOgMed": "2024-01-01",
    "tilOgMed": "2024-01-14"
  },
  "dager": [
    {
      "dato": "2024-01-01",
      "aktiviteter": []
    }
  ],
  "status": "TilUtfylling",
  "kanSendes": false,
  "bruttoBelop": null,
  "registrertArbeidssoker": null
}
\`\`\`

### Statuser
- `TilUtfylling` - Klar for utfylling
- `UnderUtfylling` - Påbegynt
- `KanSendes` - Komplett, klar for innsending
- `Innsendt` - Sendt inn
- `Ferdig` - Behandlet
