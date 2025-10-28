# Repository og Tjeneste Oversikt

Dette dokumentet gir en oversikt over de viktigste repositories i dagpengesystemet og deres ansvar.

## Frontend Applikasjoner

### dp-soknadsdialog
**Type:** Next.js applikasjon  
**Formål:** Søknadsdialog for innbyggere  
**Ansvar:**
- Presentere søknadsskjema for brukere
- Lede bruker gjennom søknadsprosessen
- Vise status og tidligere søknader

**API:** `dp-soknad`  
**URL (prod):** https://www.nav.no/dagpenger/dialog/soknad  
**Teknologi:** Next.js, React, TypeScript

---

### dp-rapportering-frontend
**Type:** React Router applikasjon (Vite)  
**Formål:** Rapportering/meldekort for innbyggere  
**Ansvar:**
- Vise rapporteringsperioder (meldekort)
- La bruker fylle ut og sende inn aktiviteter
- Vise historikk over tidligere innsendte rapporteringer

**API:** `dp-rapportering`  
**URL (prod):** https://www.nav.no/dagpenger/meldekort  
**Teknologi:** React Router, React, TypeScript, Vite

---

### dp-saksbehandling-frontend
**Type:** React Router applikasjon  
**Formål:** Saksbehandlergrensesnitt  
**Ansvar:**
- Liste og tildele oppgaver til saksbehandlere
- Vise behandlingsdata
- Tillate saksbehandler å behandle søknader og fatte vedtak
- Vise personoversikt

**API:** `dp-saksbehandling` (REST), `dp-saksbehandling-graphql` (GraphQL)  
**URL (intern):** https://saksbehandling.intern.nav.no  
**Teknologi:** React Router, React, TypeScript, GraphQL

---

## Backend APIs (BFF - Backend For Frontend)

### dp-soknad
**Type:** Kotlin/Ktor API  
**Formål:** Backend for søknadsdialog  
**Ansvar:**
- Håndtere søknadsflyt (opprett, besvar, send inn)
- Lagre søknadsdata
- Kommunisere med Quiz for søknadsmal
- Publisere events om søknadshendelser
- Journalføre søknader via behov

**Database:** PostgreSQL (`dp-soknad`)  
**OpenAPI:** `/openapi/soknad-api.yaml`  
**Events:** Produserer: `søknad_innsendt_varsel`, `søknad_slettet`, `dokumentkrav_innsendt`  
**Events:** Konsumerer: `innsending_ferdigstilt`, `søker_oppgave`, `behov` (løsninger)

**Key files:**
- `mediator/src/main/kotlin/no/nav/dagpenger/soknad/livssyklus/` - Livssyklus routes
- `mediator/src/main/kotlin/no/nav/dagpenger/soknad/innsending/` - Innsendingslogikk

---

### dp-rapportering
**Type:** Kotlin/Ktor API  
**Formål:** Backend for rapportering/meldekort  
**Ansvar:**
- Håndtere rapporteringsperioder
- Integrere med Arena/Meldekortregister
- Lagre og validere rapporteringsdata
- Publisere events om rapportering

**Database:** PostgreSQL (`dp-rapportering`)  
**OpenAPI:** `/openapi/rapportering-api.yaml`  
**Events:** Produserer: Behov for journalføring  
**Events:** Konsumerer: `rapportering_journalført`

**External integrations:**
- `dp-arena-meldeplikt-adapter` - Arena-integrasjon
- `dp-meldekortregister` - Nytt meldekortregister

**Key files:**
- `src/main/kotlin/no/nav/dagpenger/rapportering/api/RapporteringApi.kt`
- `src/main/kotlin/no/nav/dagpenger/rapportering/service/RapporteringService.kt`

---

### dp-behandling
**Type:** Kotlin/Ktor API  
**Formål:** Backend for behandling av dagpengesøknader  
**Ansvar:**
- Opprette og administrere behandlinger
- Samle opplysninger (inntekt, arbeidsforhold, etc.)
- Kjøre regelberegninger
- Håndtere avklaringer
- Fatte vedtak
- Beregne meldekort

**Database:** PostgreSQL (`dp-behandling`)  
**OpenAPI:** `/openapi/behandling-api.yaml`  
**Events:** Produserer: `vedtak_fattet`, `opplysning_svar`, behov for data  
**Events:** Konsumerer: `innsending_ferdigstilt`, `søknad_behandlingsklar`, `godkjenn_behandling`, `beregn_meldekort`

**Key files:**
- `mediator/src/main/kotlin/no/nav/dagpenger/behandling/mediator/mottak/` - Event mottakere
- `mediator/src/main/kotlin/no/nav/dagpenger/behandling/mediator/api/` - API routes

---

### dp-saksbehandling
**Type:** Kotlin/Ktor API  
**Formål:** Backend for saksbehandlergrensesnitt (oppgavehåndtering)  
**Ansvar:**
- Administrere oppgaver
- Tildele oppgaver til saksbehandlere
- Håndtere oppgavetilstander
- Notater og kommentarer
- Publisere events om oppgavehendelser

**Database:** PostgreSQL (`dp-saksbehandling`)  
**OpenAPI:** `/openapi/saksbehandling-api.yaml`  
**Events:** Produserer: `godkjenn_behandling`, `oppgave_sendt_til_kontroll`, `oppgave_returnert_til_saksbehandling`

**Key files:**
- `mediator/src/main/kotlin/no/nav/dagpenger/saksbehandling/api/OppgaveApi.kt`
- `mediator/src/main/kotlin/no/nav/dagpenger/saksbehandling/OppgaveMediator.kt`

---

### dp-saksbehandling-graphql
**Type:** Node.js/GraphQL API  
**Formål:** GraphQL API for saksbehandlergrensesnitt  
**Ansvar:**
- Tilby GraphQL API for behandlingsdata
- Aggregere data fra dp-behandling og andre kilder
- Optimalisere datahenting for frontend

**Teknologi:** Node.js, GraphQL, TypeScript  
**Backend calls:** `dp-behandling`, `dp-inntekt`, PDL

---

## Støttetjenester

### dp-mottak
**Type:** Kotlin event handler  
**Formål:** Mottak og ruting av innsendinger  
**Ansvar:**
- Motta søknader og ettersendinger
- Rute til riktig journalføringstjeneste
- Koordinere PDF-generering og journalføring

**Events:** Konsumerer behov for journalføring  
**Events:** Produserer behov for PDF og Joark

---

### dp-behov-journalforing
**Type:** Kotlin event handler  
**Formål:** Journalføre dokumenter til Joark  
**Ansvar:**
- Motta journalføringsbehov
- Koordinere med PDF-generator
- Kalle Joark API
- Publisere `innsending_ferdigstilt`

**External integrations:**
- Joark API (dokarkiv) - Journalføring

**Events:** Konsumerer: Behov for journalføring  
**Events:** Produserer: `innsending_ferdigstilt`, `rapportering_journalført`

---

### dp-behov-pdf-generator
**Type:** Kotlin service  
**Formål:** Generere PDF-dokumenter  
**Ansvar:**
- Generere PDF av søknader
- Generere PDF av rapporteringsperioder
- Generere PDF av vedtak

**Technology:** Kotlin, HTML til PDF conversion

---

### dp-inntekt
**Type:** Kotlin/Ktor API  
**Formål:** Inntektsopplysninger  
**Ansvar:**
- Hente inntektsopplysninger fra Inntektskomponenten
- Cache inntektsdata
- Klassifisere inntektstyper

**Database:** PostgreSQL  
**External integrations:**
- Inntektskomponenten (Skatteetaten)

---

### dp-mellomlagring
**Type:** Kotlin/Ktor API  
**Formål:** Mellomlagring av sensitive data  
**Ansvar:**
- Kryptert lagring av mellomdata (f.eks. utkast)
- Automatisk sletting etter tid
- Sikker tilgangskontroll

**Database:** PostgreSQL (kryptert)

---

### dp-iverksett
**Type:** Kotlin event handler  
**Formål:** Iverksetting av vedtak  
**Ansvar:**
- Motta vedtak
- Sende til utbetalingssystem (OS/UR)
- Håndtere utbetalingsstatus

**Events:** Konsumerer: `vedtak_fattet`  
**External integrations:**
- OS/UR (utbetalingssystem)

---

### dp-quiz
**Type:** Kotlin service  
**Formål:** Søknadsmalgenerator  
**Ansvar:**
- Generere søknadsmaler basert på prosesstype
- Styre søknadsflyt (hvilke spørsmål som skal stilles)
- Håndtere quiz-logikk og avhengigheter

**Events:** Konsumerer: Behov for `NySøknad`  
**Events:** Produserer: `søker_oppgave`, løsning for søknadsmal

---

## Integrasjonstjenester

### dp-arena-trakt
**Type:** Kotlin adapter  
**Formål:** Hente data fra Arena  
**Ansvar:**
- Hente saker fra Arena
- Transformere Arena-data til domenemodell
- Synkronisere vedtak og meldekort

**External integrations:**
- Arena (Oracle database og/eller API)

---

### dp-arena-meldeplikt-adapter
**Type:** Kotlin adapter  
**Formål:** Arena meldeplikt-integrasjon  
**Ansvar:**
- Sjekke om bruker har meldeplikt i Arena
- Hente meldekort fra Arena
- Sende inn meldekort til Arena

**External integrations:**
- Arena meldeplikt API

---

### dp-meldekortregister
**Type:** Kotlin service  
**Formål:** Nytt meldekortregister (erstatter Arena)  
**Ansvar:**
- Administrere rapporteringsperioder
- Lagre og behandle meldekort
- Beregne rettigheter basert på rapportering

**Database:** PostgreSQL

---

## Utility og Admin

### dp-audit-logger
**Type:** Kotlin service  
**Formål:** Revisjonssporing  
**Ansvar:**
- Logge tilganger til persondata
- Sikre sporbarhet for personvern

---

### dp-dokumentasjon
**Type:** Docusaurus site  
**Formål:** Teamdokumentasjon  
**Ansvar:**
- Teknisk dokumentasjon
- ADR (Architecture Decision Records)
- Systemkart

**URL:** https://teamdagpenger.intern.nav.no

---

## Databaser

Alle tjenester bruker PostgreSQL databaser:

### dp-soknad DB
**Tabeller:**
- `soknad_v1` - Søknadsdata
- `soknadstekst` - JSON søknadstekst
- `faktum` - Faktumverdier
- `soker_oppgave` - Søkeroppgaver

### dp-behandling DB
**Tabeller:**
- `behandling` - Behandlinger
- `opplysning` - Opplysninger/fakta
- `avklaring` - Avklaringer
- `vilkar` - Vilkår og resultater
- `vedtak` - Vedtak
- `meldekort` - Meldekortdata

### dp-saksbehandling DB
**Tabeller:**
- `oppgave_v1` - Oppgaver
- `person` - Personer
- `notat` - Notater og kommentarer

### dp-rapportering DB
**Tabeller:**
- `rapporteringsperiode` - Rapporteringsperioder
- `aktivitet` - Aktiviteter per dag

---

## Eksterne systemer

### Joark (dokarkiv)
**Formål:** Dokumentarkiv  
**API:** `/dokarkiv/v1/journalpost`  
**Brukes av:** `dp-behov-journalforing`

### Inntektskomponenten
**Formål:** Inntektsopplysninger fra Skatteetaten  
**Brukes av:** `dp-inntekt`

### PDL (Person Data Løsningen)
**Formål:** Personopplysninger  
**Brukes av:** `dp-behandling`, `dp-saksbehandling`

### Arena
**Formål:** Gammelt saksbehandlingssystem  
**Integreres via:** `dp-arena-trakt`, `dp-arena-meldeplikt-adapter`

### OS/UR (Oppdrag/Utbetaling)
**Formål:** Utbetalingssystem  
**Brukes av:** `dp-iverksett`

---

## Teknologi-stack

### Backend
- **Språk:** Kotlin
- **Framework:** Ktor
- **Database:** PostgreSQL
- **Messaging:** Kafka (Rapid & Rivers)
- **Containerization:** Docker
- **Deployment:** NAIS (Kubernetes)

### Frontend
- **Språk:** TypeScript
- **Frameworks:** Next.js, React Router (Vite)
- **Styling:** CSS Modules, Aksel (NAV designsystem)
- **State:** React Query, Context API

### DevOps
- **CI/CD:** GitHub Actions
- **Monitoring:** Grafana, Prometheus
- **Logging:** Kibana, Secure logs
- **Alerting:** Slack integrasjon
