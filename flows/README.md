# Dagpenger Flow Documentation - README

Dette er den første iterasjonen av flow-dokumentasjon for dagpengesystemet. Dokumentasjonen gir en oversikt over de viktigste brukerflyten i systemet.

## 📚 Hva er dokumentert

Denne dokumentasjonen dekker:

### ✅ Hovedflyter dokumentert

#### Søknadsprosessen
- [Start ny søknad](./soknad/01-start-ny-soknad.md) - Hvordan en bruker starter en ny dagpengesøknad
- [Besvar søknadsspørsmål](./soknad/02-besvar-faktum.md) - Utfylling av søknadsinformasjon
- [Ferdigstill søknad](./soknad/03-ferdigstill-soknad.md) - Innsending og journalføring av søknad

#### Rapporteringsprosessen
- [Hent rapporteringsperioder](./rapportering/01-hent-perioder.md) - Hente og starte rapporteringsperioder
- [Send inn rapportering](./rapportering/03-send-inn.md) - Innsending av utfylt rapporteringsperiode

#### Saksbehandling
- [Tildel og behandle oppgave](./saksbehandling/02-tildel-oppgave.md) - Saksbehandlers arbeid med oppgaver

### ✅ Arkitekturdokumentasjon
- [Event Katalog](./architecture/event-catalog.md) - Oversikt over alle viktige events
- [Repository Oversikt](./architecture/repositories.md) - Beskrivelse av alle repositories
- [Rapid & Rivers](./architecture/rapids-rivers.md) - Forklaring av event-drevet arkitektur

## 🔄 Hva mangler

Dette er en første versjon. Følgende flyter mangler fortsatt dokumentasjon:

### Søknadsprosessen
- [ ] Hent mine søknader
- [ ] Slett søknad
- [ ] Ettersending av dokumentasjon
- [ ] Hent arbeidsforhold
- [ ] Hent personalia

### Rapporteringsprosessen
- [ ] Fyll ut aktiviteter
- [ ] Endre innsendt rapportering
- [ ] Historikk over tidligere rapporteringer
- [ ] Arbeidsøkerregistrering

### Saksbehandling
- [ ] Hent alle oppgaver
- [ ] Søk etter person
- [ ] Behandle avklaringer
- [ ] Send til kontroll
- [ ] Returner fra kontroll
- [ ] Notat på oppgave

### Behandlingsprosessen
- [ ] Opprett behandling
- [ ] Hent behandlingsopplysninger
- [ ] Innhenting av inntekt
- [ ] Innhenting av arbeidsforhold
- [ ] Regelberegninger
- [ ] Fatt vedtak
- [ ] Iverksett vedtak

### Event-drevne flyter
- [ ] Automatisk behandling fra søknad
- [ ] Meldekortberegning
- [ ] Vedtak til utbetaling
- [ ] Arena-integrasjon
- [ ] Påminnelser

## 📖 Hvordan lese dokumentasjonen

Hver flyt dokumenteres med:

1. **Beskrivelse** - Hva flyten gjør
2. **Frontend til BFF** - API-kall fra frontend til backend
3. **Backend prosessering** - Hva skjer i backend
4. **Database** - Hvilke databaser som brukes
5. **Events** - Hvilke events som produseres/konsumeres
6. **Nedstrøms tjenester** - Videre prosessering
7. **Mermaid diagram** - Visuell representasjon av flyten
8. **Nøkkelinformasjon** - Oppsummering av viktig info

## 🎯 Hvordan bruke dokumentasjonen

### For utviklere
- Forstå hvordan systemet henger sammen
- Trace bugs gjennom hele flyten
- Identifisere avhengigheter mellom tjenester

### For AI-agenter
- Dokumentasjonen er strukturert for å være lesbar for AI
- Mermaid-diagrammer gir visuell kontekst
- Event-katalogen gir oversikt over alle meldinger

### For nye teammedlemmer
- Få oversikt over systemet
- Forstå brukerreiser
- Lære event-drevet arkitektur

## 🔧 Vedlikehold av dokumentasjon

### Når oppdatere
Dokumentasjonen bør oppdateres når:
- Nye API-endepunkter legges til
- Events endres eller legges til
- Flyter endres betydelig
- Nye tjenester introduseres

### Hvordan bidra
1. Identifiser manglende eller utdatert dokumentasjon
2. Bruk eksisterende flyter som mal
3. Inkluder:
   - API endpoints
   - Events (produsert/konsumert)
   - Database-interaksjoner
   - Mermaid-diagram
4. Oppdater `index.md` hvis du legger til nye flyter

## 📂 Struktur

\`\`\`
flows/
├── index.md                          # Hovedoversikt
├── README.md                         # Dette dokumentet
├── soknad/                           # Søknadsflyter
│   ├── 01-start-ny-soknad.md
│   ├── 02-besvar-faktum.md
│   └── 03-ferdigstill-soknad.md
├── rapportering/                     # Rapporteringsflyter
│   ├── 01-hent-perioder.md
│   └── 03-send-inn.md
├── saksbehandling/                   # Saksbehandlingsflyter
│   └── 02-tildel-oppgave.md
├── behandling/                       # Behandlingsflyter
│   └── (kommer)
├── events/                           # Event-drevne flyter
│   └── (kommer)
└── architecture/                     # Arkitekturdokumentasjon
    ├── event-catalog.md             # Event katalog
    ├── repositories.md              # Repository oversikt
    └── rapids-rivers.md             # Rapid & Rivers forklaring
\`\`\`

## 🔍 Søk i dokumentasjon

For å finne informasjon om:

### Et spesifikt API endpoint
Søk i flow-filene eller se OpenAPI specs:
- `dp-soknad/openapi/src/main/resources/soknad-api.yaml`
- `dp-rapportering/openapi/src/main/resources/rapportering-api.yaml`
- `dp-behandling/openapi/src/main/resources/behandling-api.yaml`
- `dp-saksbehandling/openapi/src/main/resources/saksbehandling-api.yaml`

### En event
Se [Event Katalog](./architecture/event-catalog.md)

### En tjeneste
Se [Repository Oversikt](./architecture/repositories.md)

### Hvordan events fungerer
Se [Rapid & Rivers](./architecture/rapids-rivers.md)

## 🚀 Neste steg

For å gjøre dokumentasjonen komplett, fokuser på:

1. **Prioriterte flyter** (høy verdi):
   - Opprett behandling (fra søknad til behandling)
   - Vedtak til utbetaling (behandling til penger)
   - Meldekortberegning (rapportering til utbetaling)

2. **Manglende søknadsflyter**:
   - Ettersending
   - Mine søknader
   - Arbeidsforhold

3. **Detaljerte saksbehandlingsflyter**:
   - Alle oppgaveoperasjoner
   - Behandling av avklaringer
   - Kontrollflyt

4. **Event dokumentasjon**:
   - Komplette event-specs
   - Event-consumers oversikt
   - Event-producers oversikt

## 💡 Tips

### Trace en request
1. Start med frontend-filen (f.eks. `dp-soknadsdialog`)
2. Følg API-kallet til BFF (f.eks. `dp-soknad`)
3. Se hvilke events som produseres
4. Sjekk event-katalogen for konsumenter
5. Følg til nedstrøms tjenester

### Debug en flyt
1. Finn flyten i dokumentasjonen
2. Identifiser alle touchpoints
3. Sjekk Kafka for events (hvis event-drevet)
4. Se database-state i hver tjeneste
5. Bruk logging context for å trace

## 📞 Kontakt

For spørsmål om dokumentasjonen:
- Team: #team-dagpenger (Slack)
- Kode: https://github.com/navikt/dagpenger (monorepo)

## 📜 Lisens

Denne dokumentasjonen følger samme lisens som kodebasen (MIT).

---

**Versjon:** 1.0  
**Opprettet:** 2025-10-28  
**Sist oppdatert:** 2025-10-28
