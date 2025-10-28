# Quick Reference - API Endpoints og Events

Dette er en rask referanse for de viktigste API-endepunktene og events i dagpengesystemet.

## 🔌 API Endpoints

### dp-soknad (Søknads-API)
**Base URL:** `https://dp-soknad.intern.nav.no/arbeid/dagpenger/soknadapi`

| Endpoint | Method | Beskrivelse | Flow |
|----------|--------|-------------|------|
| `/soknad` | POST | Start ny søknad | [01-start-ny-soknad](./soknad/01-start-ny-soknad.md) |
| `/soknad/{uuid}/neste` | GET | Hent neste søkeroppgave | [02-besvar-faktum](./soknad/02-besvar-faktum.md) |
| `/soknad/{uuid}/faktum/{faktumId}` | PUT | Besvar faktum | [02-besvar-faktum](./soknad/02-besvar-faktum.md) |
| `/soknad/{uuid}/status` | GET | Hent søknadsstatus | [02-besvar-faktum](./soknad/02-besvar-faktum.md) |
| `/soknad/{uuid}/ferdigstill` | PUT | Ferdigstill og send inn | [03-ferdigstill-soknad](./soknad/03-ferdigstill-soknad.md) |
| `/arbeidsforhold` | GET | Hent arbeidsforhold | - |

---

### dp-rapportering (Rapporterings-API)
**Base URL:** `https://dp-rapportering.intern.nav.no`

| Endpoint | Method | Beskrivelse | Flow |
|----------|--------|-------------|------|
| `/harmeldeplikt` | GET | Sjekk om bruker har meldeplikt | [01-hent-perioder](./rapportering/01-hent-perioder.md) |
| `/rapporteringsperioder` | GET | Hent ikke-innsendte perioder | [01-hent-perioder](./rapportering/01-hent-perioder.md) |
| `/rapporteringsperioder/innsendte` | GET | Hent innsendte perioder | - |
| `/rapporteringsperiode/{id}` | GET | Hent spesifikk periode | [01-hent-perioder](./rapportering/01-hent-perioder.md) |
| `/rapporteringsperiode/{id}/start` | POST | Start utfylling | [01-hent-perioder](./rapportering/01-hent-perioder.md) |
| `/rapporteringsperiode` | POST | Send inn periode | [03-send-inn](./rapportering/03-send-inn.md) |

---

### dp-saksbehandling (Saksbehandlings-API)
**Base URL:** `https://dp-saksbehandling.intern.dev.nav.no`

| Endpoint | Method | Beskrivelse | Flow |
|----------|--------|-------------|------|
| `/oppgave` | GET | Hent oppgaver (med filtre) | [02-tildel-oppgave](./saksbehandling/02-tildel-oppgave.md) |
| `/oppgave/neste` | PUT | Tildel neste oppgave | [02-tildel-oppgave](./saksbehandling/02-tildel-oppgave.md) |
| `/oppgave/{oppgaveId}` | GET | Hent spesifikk oppgave | - |
| `/oppgave/{oppgaveId}/notat` | PUT | Legg til notat | - |
| `/oppgave/{oppgaveId}/godkjenn` | POST | Godkjenn oppgave | [02-tildel-oppgave](./saksbehandling/02-tildel-oppgave.md) |

---

### dp-behandling (Behandlings-API)
**Base URL:** `https://dp-behandling.intern.nav.no`

| Endpoint | Method | Beskrivelse | Flow |
|----------|--------|-------------|------|
| `/behandling` | POST | Hent behandlinger for person | - |
| `/behandling/{behandlingId}` | GET | Hent spesifikk behandling | [02-tildel-oppgave](./saksbehandling/02-tildel-oppgave.md) |
| `/person/behandling` | POST | Opprett ny behandling | - |
| `/opplysningstyper` | GET | Hent alle opplysningstyper | - |

---

## 📨 Events

### Produserte av dp-soknad

| Event | Beskrivelse | Flow |
|-------|-------------|------|
| `søknad_innsendt_varsel` | Bruker har sendt inn søknad | [03-ferdigstill-soknad](./soknad/03-ferdigstill-soknad.md) |
| `søknad_slettet` | Bruker har slettet søknad | - |
| `dokumentkrav_innsendt` | Ettersending mottatt | - |
| `ny_quiz_mal` | Ny søknadsmal generert | - |
| Behov: `NySøknad` | Be om søknadsmal | [01-start-ny-soknad](./soknad/01-start-ny-soknad.md) |
| Behov: `NyInnsending` | Be om journalføring | [03-ferdigstill-soknad](./soknad/03-ferdigstill-soknad.md) |

### Konsumert av dp-soknad

| Event | Handling | Flow |
|-------|----------|------|
| `innsending_ferdigstilt` | Oppdater med journalpostId | [03-ferdigstill-soknad](./soknad/03-ferdigstill-soknad.md) |
| `søker_oppgave` | Motta nye spørsmål fra Quiz | [02-besvar-faktum](./soknad/02-besvar-faktum.md) |
| `behov` (løsning for NySøknad) | Motta prosessversjon | [01-start-ny-soknad](./soknad/01-start-ny-soknad.md) |

---

### Produserte av dp-rapportering

| Event | Beskrivelse | Flow |
|-------|-------------|------|
| Behov: `JournalførRapportering` | Be om journalføring | [03-send-inn](./rapportering/03-send-inn.md) |
| `rapportering_innsendt` | Sendt til baksystem | [03-send-inn](./rapportering/03-send-inn.md) |

### Konsumert av dp-rapportering

| Event | Handling | Flow |
|-------|----------|------|
| `rapportering_journalført` | Oppdater med journalpostId | [03-send-inn](./rapportering/03-send-inn.md) |

---

### Produserte av dp-behandling

| Event | Beskrivelse | Flow |
|-------|-------------|------|
| `søknad_behandlingsklar` | Behandling kan startes | [03-ferdigstill-soknad](./soknad/03-ferdigstill-soknad.md) |
| `vedtak_fattet` | Vedtak er fattet | - |
| `opplysning_svar` | Svar på opplysningsbehov | [02-tildel-oppgave](./saksbehandling/02-tildel-oppgave.md) |
| Behov: `Inntekt` | Be om inntektsopplysninger | - |
| Behov: `Arbeidsforhold` | Be om arbeidsforhold | - |

### Konsumert av dp-behandling

| Event | Handling | Flow |
|-------|----------|------|
| `innsending_ferdigstilt` | Start behandling fra søknad | [03-ferdigstill-soknad](./soknad/03-ferdigstill-soknad.md) |
| `godkjenn_behandling` | Godkjenn og fatt vedtak | [02-tildel-oppgave](./saksbehandling/02-tildel-oppgave.md) |
| `beregn_meldekort` | Beregn meldekort | [03-send-inn](./rapportering/03-send-inn.md) |
| `opprett_behandling` | Opprett ny behandling | - |
| `avbryt_behandling` | Avbryt behandling | - |

---

### Produserte av dp-saksbehandling

| Event | Beskrivelse | Flow |
|-------|-------------|------|
| `godkjenn_behandling` | Saksbehandler godkjenner | [02-tildel-oppgave](./saksbehandling/02-tildel-oppgave.md) |
| `oppgave_sendt_til_kontroll` | Sendt til 4-øyne kontroll | - |
| `oppgave_returnert_til_saksbehandling` | Returnert fra kontroll | - |

---

### Fellesevents (Journalføring)

| Event | Produsent | Konsument | Flow |
|-------|-----------|-----------|------|
| `innsending_ferdigstilt` | dp-behov-journalforing | dp-soknad, dp-behandling | [03-ferdigstill-soknad](./soknad/03-ferdigstill-soknad.md) |
| `rapportering_journalført` | dp-behov-journalforing | dp-rapportering | [03-send-inn](./rapportering/03-send-inn.md) |

---

## 🗄️ Databaser

| Repository | Database | Viktige tabeller |
|------------|----------|------------------|
| dp-soknad | `dp-soknad` | `soknad_v1`, `faktum`, `soknadstekst` |
| dp-rapportering | `dp-rapportering` | `rapporteringsperiode` |
| dp-behandling | `dp-behandling` | `behandling`, `opplysning`, `avklaring`, `vedtak` |
| dp-saksbehandling | `dp-saksbehandling` | `oppgave_v1`, `person`, `notat` |

---

## 🔗 Eksterne systemer

| System | Formål | Brukt av |
|--------|--------|----------|
| Joark (dokarkiv) | Journalføring | dp-behov-journalforing |
| Inntektskomponenten | Inntektsopplysninger | dp-inntekt |
| PDL | Personopplysninger | dp-behandling, dp-saksbehandling |
| Arena | Gammelt saksystem | dp-arena-trakt, dp-arena-meldeplikt-adapter |
| OS/UR | Utbetaling | dp-iverksett |

---

## 🎯 Vanlige brukerreiser

### Søknad til vedtak
1. `POST /soknad` → Start søknad
2. `PUT /soknad/{uuid}/faktum/{id}` → Besvar spørsmål (flere ganger)
3. `PUT /soknad/{uuid}/ferdigstill` → Send inn
4. Event: `søknad_innsendt_varsel` → Varsling
5. Event: `innsending_ferdigstilt` → Journalført
6. Event: `søknad_behandlingsklar` → Behandling starter
7. `PUT /oppgave/neste` → Saksbehandler tar oppgave
8. GraphQL: Behandle søknad
9. `POST /oppgave/{id}/godkjenn` → Godkjenn
10. Event: `vedtak_fattet` → Vedtak fattet

### Rapportering til utbetaling
1. `GET /rapporteringsperioder` → Hent perioder
2. `POST /rapporteringsperiode/{id}/start` → Start utfylling
3. `POST /rapporteringsperiode` → Send inn
4. Event: `beregn_meldekort` → Beregn utbetaling
5. Event: `vedtak_fattet` → Utbetaling klar

---

## 📖 Mer informasjon

- [Komplett event katalog](./architecture/event-catalog.md)
- [Repository oversikt](./architecture/repositories.md)
- [Rapid & Rivers forklaring](./architecture/rapids-rivers.md)
- [Hovedindex](./index.md)

---

**Tips:** Bruk Ctrl+F for å søke etter spesifikke endpoints eller events!
