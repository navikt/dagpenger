# Flyt: Besvar søknadsspørsmål (faktum)

## Beskrivelse
Denne flyten beskriver hvordan en bruker fyller ut søknadsinformasjon ved å besvare faktum (spørsmål).

## Frontend til BFF

### 1. Frontend: dp-soknadsdialog
**Trigger:** Bruker fyller ut søknadsskjema

**URL:** `/soknad/[soknad_uuid]/[seksjon]` (Next.js dynamic routes)

**Filer:** 
- `dp-soknadsdialog/src/pages/soknad/[soknadId]/[seksjonId].tsx` (eller lignende)
- Bruker React/Next.js for dynamisk routing

### 2. Hent neste søkeroppgave
**API-kall:**
- `GET /soknad/{uuid}/neste`
  - Repository: `dp-soknad`

**Route:** `GET /soknad/{uuid}/neste`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/påbegynt/NesteSøkerOppgaveRoute.kt`

**Prosessering:**
1. Validerer at innlogget bruker eier søknaden
2. Henter neste faktum som må besvares
3. Returnerer faktum-informasjon eller indikerer at søknaden er komplett

**Database:**
- Tabell: `soknad_v1` - Søknadsdata
- Tabell: `faktum` - Faktumverdier
- Database: `dp-soknad` PostgreSQL

**Response:**
- Faktum-objekt med:
  - `id` - Faktum ID
  - `type` - Type spørsmål (tekst, dato, valg, etc.)
  - `spørsmål` - Spørsmålstekst
  - `svar` - Eksisterende svar (hvis noen)
  - `validering` - Valideringsregler

## Besvare faktum

### 3. Besvar faktum (svar på spørsmål)
**Frontend action:** Bruker fyller ut og sender svar

**API-kall:**
- `PUT /soknad/{uuid}/faktum/{faktumId}`
  - Request body: Svar (JSON)
  - Repository: `dp-soknad`

**Route:** `PUT /soknad/{uuid}/faktum/{faktumId}`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/påbegynt/BesvarFaktumRoute.kt`

**Prosessering:**
1. Validerer at innlogget bruker eier søknaden
2. Mottar faktum-svar
3. Validerer svar mot regler
4. Oppdaterer søknad med svaret
5. Publiserer event om faktum-svar
6. Kjører quiz-logikk for å avgjøre neste spørsmål

**Database:**
- Tabell: `faktum` - Lagrer faktumverdier
  - `faktum_id` (PK)
  - `soknad_uuid` (FK)
  - `verdi` (JSONB)
  - `opprettet`
  - `endret`

**Event produsert:**
Via observer når faktum besvares - kan trigge nye søkeroppgaver

**Response:**
- Status: `200 OK` eller `204 No Content`
- Kan returnere oppdatert søknadsstatus

## Søkeroppgave mottak (Quiz-genererte oppgaver)

### 4. Motta søkeroppgave fra Quiz
**Event konsumert:** `søker_oppgave`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/påbegynt/SøkerOppgaveMottak.kt`

**Beskrivelse:** Quiz-systemet sender oppgaver (spørsmål) som skal besvares basert på tidligere svar

**Prosess:**
1. Mottar søkeroppgave fra Rapid
2. Lagrer oppgave i database
3. Kobler til søknad

**Database:**
- Tabell: `soker_oppgave`
- Kobler oppgave til søknad

## Hent søknadsstatus

### 5. Hent søknadsstatus
**API-kall:**
- `GET /soknad/{uuid}/status`
  - Repository: `dp-soknad`

**Route:** `GET /soknad/{uuid}/status`

**Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/status/StatusRoute.kt`

**Prosessering:**
1. Henter søknadsstatus
2. Returnerer informasjon om:
   - Antall besvarte/totale spørsmål
   - Prosent ferdig
   - Om søknaden kan sendes inn
   - Påkrevde dokumenter

**Response:**
\`\`\`json
{
  "soknadUuid": "uuid",
  "tilstand": "Påbegynt",
  "prosent": 45,
  "kanSendes": false,
  "antallSvar": 12,
  "totaltAntall": 27
}
\`\`\`

## Faktum-typer

### Støttede faktum-typer
- **Tekst** - Fritekst input
- **Tall** - Numerisk verdi
- **Dato** - Datovelger
- **Boolean** - Ja/Nei
- **Generator** - Liste med flere elementer (f.eks. arbeidsforhold)
- **Land** - Landvelger
- **Envalg** - Velg ett alternativ
- **Flervalg** - Velg flere alternativer
- **Periode** - Fra-til dato

### Faktum-validering
Validering skjer både frontend og backend:
- Påkrevd felt
- Format (dato, nummer, etc.)
- Rekkevidesjekk (min/maks)
- Avhengigheter (basert på andre svar)

## Mermaid diagram

\`\`\`mermaid
sequenceDiagram
    participant User as Bruker
    participant FE as dp-soknadsdialog
    participant API as dp-soknad API
    participant DB as dp-soknad DB
    participant Rapid as Kafka Rapid
    participant Quiz as dp-quiz

    User->>FE: Navigerer til søknad
    FE->>API: GET /soknad/{uuid}/neste
    API->>DB: Hent neste oppgave
    API->>FE: Faktum-objekt
    FE->>User: Vis spørsmål

    User->>FE: Fyller ut svar
    User->>FE: Klikk "Neste"
    FE->>API: PUT /soknad/{uuid}/faktum/{id}
    API->>API: Valider svar
    API->>DB: Lagre faktum
    API->>FE: 200 OK

    API->>Rapid: Publiser faktum_besvart (implisitt)
    
    alt Trenger nye spørsmål fra Quiz
        Rapid->>Quiz: Faktum-endring
        Quiz->>Quiz: Evaluer quiz-logikk
        Quiz->>Rapid: Publiser søker_oppgave
        Rapid->>API: Motta søker_oppgave
        API->>DB: Lagre nye oppgaver
    end

    FE->>API: GET /soknad/{uuid}/neste
    API->>DB: Hent neste oppgave
    API->>FE: Neste faktum eller "ferdig"
    FE->>User: Vis neste spørsmål eller oppsummering

    loop Flere spørsmål
        User->>FE: Besvar faktum
        FE->>API: PUT faktum
        API->>DB: Lagre
    end

    FE->>API: GET /soknad/{uuid}/status
    API->>DB: Hent status
    API->>FE: Status (kanSendes: true)
    FE->>User: Vis "Send søknad"-knapp
\`\`\`

## Nøkkelinformasjon

### API Endpoints
- `GET /soknad/{uuid}/neste` - Hent neste søkeroppgave
- `PUT /soknad/{uuid}/faktum/{faktumId}` - Besvar faktum
- `GET /soknad/{uuid}/status` - Hent søknadsstatus
- `GET /soknad/{uuid}/fakta` - Hent alle faktum for søknad

### Events produsert
- `faktum_besvart` (implisitt via tilstandsendring)

### Events konsumert
- `søker_oppgave` - Nye spørsmål fra Quiz
  - **Fil:** `dp-soknad/mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/påbegynt/SøkerOppgaveMottak.kt`

### Databaser
- `dp-soknad` PostgreSQL
  - `soknad_v1` - Søknad metadata
  - `faktum` - Faktumverdier
  - `soker_oppgave` - Søkeroppgaver fra Quiz

### Faktum-struktur

\`\`\`json
{
  "id": "faktum-123",
  "type": "tekst",
  "beskrivendeId": "faktum.inntekt.siste-12-mnd",
  "svar": "450000",
  "gyldigeValg": null,
  "templates": {
    "nb": {
      "text": "Hva var din totale inntekt siste 12 måneder?",
      "help": "Oppgi brutto årsinntekt..."
    }
  },
  "validering": {
    "required": true,
    "type": "number",
    "min": 0
  }
}
\`\`\`

### Søknadstilstander
- `Påbegynt` - Under utfylling
- `UnderBehandling` - Sendt til behandling (etter ferdigstilling)
- `Slettet` - Bruker har slettet søknad

### Notater
- Quiz-systemet (dp-quiz) styrer flyt av spørsmål basert på svar
- Faktum kan ha avhengigheter til andre faktum
- Generator-faktum kan skape dynamiske lister (f.eks. flere arbeidsforhold)
- Svar valideres både frontend og backend for sikkerhet
