# Flyt: Tildel og behandle oppgave

## Beskrivelse
Denne flyten beskriver prosessen fra en saksbehandler tildeler seg en oppgave til oppgaven behandles og vedtak fattes.

## Frontend til BFF

### 1. Frontend: dp-saksbehandling-frontend
**Trigger:** Saksbehandler navigerer til "Mine oppgaver" eller "Alle oppgaver"

**URL:** `/mine-oppgaver` eller `/alle-oppgaver` (React Router routes)

**Filer:** 
- `dp-saksbehandling-frontend/app/routes/mine-oppgaver.tsx`
- `dp-saksbehandling-frontend/app/routes/alle-oppgaver.tsx`

**API-kall:**
- `GET /oppgave?mineOppgaver=true` - Hent mine oppgaver
- `GET /oppgave` - Hent alle oppgaver
  - Repository: `dp-saksbehandling`

### 2. Tildel neste oppgave
**Frontend action:** Saksbehandler klikker "Neste oppgave"

**API-kall:**
- `PUT /oppgave/neste`
  - Request body: `NesteOppgave` (filtre for oppgavetyper)
  - Repository: `dp-saksbehandling`

**Fil:** `dp-saksbehandling/mediator/src/main/kotlin/no/nav/dagpenger/saksbehandling/api/OppgaveApi.kt`

**Prosessering:**
1. Henter saksbehandlers ident fra token
2. Finner neste tilgjengelige oppgave basert på filtre
3. Tildeler oppgaven til saksbehandler
4. Oppdaterer oppgavestatus til "Under behandling"
5. Returnerer oppgavedetaljer

**Database:**
- Tabell: `oppgave_v1`
- Status: `UNDER_BEHANDLING`
- Felter: `saksbehandler_ident`, `tildelt_tidspunkt`
- Database: `dp-saksbehandling` PostgreSQL

**Response:**
- Status: `200 OK`
- Body: `Oppgave` objekt med detaljer

**Response (ingen oppgave):**
- Status: `404 Not Found`

## Behandling via GraphQL

### 3. Frontend: Hent behandlingsdata
**URL:** `/oppgave/{oppgaveId}/dagpenger-rett/{behandlingId}`

**Fil:** `dp-saksbehandling-frontend/app/routes/oppgave.$oppgaveId.dagpenger-rett.$behandlingId.tsx`

**GraphQL-kall til dp-saksbehandling-graphql:**
```graphql
query HentBehandling($behandlingId: UUID!) {
  behandling(id: $behandlingId) {
    id
    person { ... }
    opplysninger { ... }
    avklaringer { ... }
    vilkår { ... }
  }
}
```

**Service:** `dp-saksbehandling-graphql`

**Backend API-kall:**
- `GET /behandling/{behandlingId}` (dp-behandling API)

### 4. Backend: dp-behandling
**Route:** `GET /behandling/{behandlingId}`

**Fil:** `dp-behandling/mediator/src/main/kotlin/no/nav/dagpenger/behandling/mediator/api/BehandlingApi.kt`

**Prosessering:**
1. Henter behandling fra database
2. Henter alle opplysninger (inntekt, arbeidsforhold, etc.)
3. Henter avklaringer som må gjøres
4. Beregner vilkårsstatus
5. Returnerer komplett behandlingsobjekt

**Database:**
- Tabell: `behandling`
- Tabell: `opplysning` - Alle fakta om bruker
- Tabell: `avklaring` - Ting som må avklares manuelt
- Tabell: `vilkår` - Resultat av regelberegninger
- Database: `dp-behandling` PostgreSQL

**External API calls:**
- `dp-inntekt` - Hent inntektsopplysninger
- `dp-arena-trakt` - Hent Arena-data (hvis relevant)
- PDL (via proxy) - Personopplysninger

## Avklaring og vedtak

### 5. Saksbehandler gjør avklaringer
**Frontend action:** Saksbehandler besvarer avklaringer

**URL:** `/oppgave/{oppgaveId}/dagpenger-rett/{behandlingId}/behandle`

**GraphQL mutation:**
```graphql
mutation BesvarAvklaring($avklaringId: UUID!, $svar: AvklaringSvar!) {
  besvarAvklaring(avklaringId: $avklaringId, svar: $svar) {
    id
    status
  }
}
```

**Backend prosess (dp-behandling):**
1. Mottar avklaringssvar
2. Oppdaterer behandling med svaret
3. Kjører regler på nytt med oppdaterte opplysninger
4. Publiserer event om opplysningssvar

**Event produsert:** `opplysning_svar`
- Inneholder: `behandlingId`, `opplysningId`, `svar`

### 6. Fatt vedtak
**Frontend action:** Saksbehandler godkjenner behandling

**API-kall (REST):**
- `POST /oppgave/{oppgaveId}/godkjenn`
  - Repository: `dp-saksbehandling`

**Prosess i dp-saksbehandling:**
1. Validerer at alle avklaringer er besvart
2. Markerer oppgave som ferdig
3. Publiserer event

**Event produsert:** `godkjenn_behandling`
- Konsument: `dp-behandling`

**Fil:** `dp-behandling/mediator/src/main/kotlin/no/nav/dagpenger/behandling/mediator/mottak/GodkjennBehandlingMottak.kt`

**Prosess i dp-behandling:**
1. Mottar godkjenning
2. Beregner endelig resultat
3. Oppretter vedtak
4. Publiserer vedtak-event

**Database:**
- Tabell: `vedtak` (ny rad)
- Tabell: `behandling` (status = Ferdig)

**Event produsert:** `vedtak_fattet`

## Mermaid diagram

\`\`\`mermaid
sequenceDiagram
    participant SB as Saksbehandler
    participant FE as dp-saksbehandling-frontend
    participant Sak as dp-saksbehandling API
    participant SakDB as dp-saksbehandling DB
    participant GQL as dp-saksbehandling-graphql
    participant BehAPI as dp-behandling API
    participant BehDB as dp-behandling DB
    participant Rapid as Kafka Rapid
    participant Inntekt as dp-inntekt
    participant Iverksett as dp-iverksett

    SB->>FE: Klikk "Neste oppgave"
    FE->>Sak: PUT /oppgave/neste
    Sak->>SakDB: Finn neste oppgave
    Sak->>SakDB: Tildel til saksbehandler
    Sak->>FE: 200 OK (Oppgave)
    FE->>SB: Vis oppgave

    FE->>GQL: GraphQL: HentBehandling
    GQL->>BehAPI: GET /behandling/{id}
    BehAPI->>BehDB: Hent behandlingsdata
    BehAPI->>Inntekt: Hent inntekt
    Inntekt-->>BehAPI: Inntektsdata
    BehAPI->>BehAPI: Beregn vilkår
    BehAPI->>GQL: Behandlingsdata
    GQL->>FE: Behandling
    FE->>SB: Vis behandling

    SB->>FE: Besvar avklaringer
    FE->>GQL: GraphQL: BesvarAvklaring
    GQL->>BehAPI: POST /behandling/{id}/avklaring
    BehAPI->>BehDB: Lagre svar
    BehAPI->>BehAPI: Kjør regler på nytt
    BehAPI->>Rapid: Publiser opplysning_svar
    BehAPI->>GQL: Oppdatert status
    GQL->>FE: Behandling oppdatert
    FE->>SB: Vis oppdatert behandling

    SB->>FE: Klikk "Godkjenn"
    FE->>Sak: POST /oppgave/{id}/godkjenn
    Sak->>SakDB: Marker oppgave ferdig
    Sak->>Rapid: Publiser godkjenn_behandling
    Sak->>FE: 200 OK
    FE->>SB: Oppgave ferdig

    Rapid->>BehAPI: Motta godkjenn_behandling
    BehAPI->>BehDB: Opprett vedtak
    BehAPI->>Rapid: Publiser vedtak_fattet
    
    Rapid->>Iverksett: Iverksett vedtak
    Iverksett->>Iverksett: Send til utbetaling
\`\`\`

## Nøkkelinformasjon

### API Endpoints
**dp-saksbehandling:**
- `GET /oppgave` - List oppgaver
- `PUT /oppgave/neste` - Tildel neste oppgave
- `GET /oppgave/{oppgaveId}` - Hent oppgave
- `POST /oppgave/{oppgaveId}/godkjenn` - Godkjenn oppgave

**dp-behandling:**
- `GET /behandling/{behandlingId}` - Hent behandling
- `POST /behandling/{behandlingId}/avklaring` - Besvar avklaring
- `GET /behandling/{behandlingId}/opplysninger` - Hent opplysninger

**dp-saksbehandling-graphql:**
- GraphQL endpoint: `/graphql`

### Events produsert
- `opplysning_svar` - Svar på avklaring gitt
- `godkjenn_behandling` - Behandling godkjent
- `vedtak_fattet` - Vedtak fattet

### Events konsumert
- `godkjenn_behandling` - dp-behandling konsumerer

### Databaser
- `dp-saksbehandling` PostgreSQL
  - `oppgave_v1` - Oppgaver
    - `oppgave_id` (PK)
    - `behandling_id`
    - `saksbehandler_ident`
    - `tilstand` (KLAR_TIL_BEHANDLING, UNDER_BEHANDLING, FERDIG)
- `dp-behandling` PostgreSQL
  - `behandling` - Behandlinger
  - `opplysning` - Opplysninger
  - `avklaring` - Avklaringer
  - `vedtak` - Vedtak

### Eksterne API-kall
- `dp-inntekt` - Hent inntektsopplysninger
- PDL (Person) - Hent personopplysninger
- `dp-arena-trakt` - Hent Arena-data
