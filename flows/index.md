# Dagpenger System Flows

Dette dokumentet inneholder en oversikt over alle hovedflyter i dagpengesystemet. Hver flyt er dokumentert i en egen mappe med tilhørende Mermaid-diagrammer.

## Innbyggerflater

### Søknadsprosessen
1. [Start ny søknad](./soknad/01-start-ny-soknad.md) - Opprett ny dagpengesøknad
2. [Besvar søknadsspørsmål](./soknad/02-besvar-faktum.md) - Fylle ut søknadsinformasjon
3. [Ferdigstill søknad](./soknad/03-ferdigstill-soknad.md) - Send inn søknad
4. [Journalføring av søknad](./soknad/04-journalforing.md) - Journalføring og arkivering av innsendt søknad

### Rapporteringsprosessen
1. [Hent rapporteringsperioder](./rapportering/01-hent-perioder.md) - Liste rapporteringsperioder for bruker
2. [Fyll ut rapporteringsperiode](./rapportering/02-fyll-ut-periode.md) - Registrere aktiviteter og arbeid
3. [Send inn rapportering](./rapportering/03-send-inn.md) - Innsending av utfylt rapporteringsperiode
4. [Journalføring av rapportering](./rapportering/04-journalforing.md) - Journalføring av rapporteringsperiode

## Saksbehandlerflater

### Saksbehandling
1. [Hent oppgaver](./saksbehandling/01-hent-oppgaver.md) - Liste og tildele oppgaver
2. [Tildel neste oppgave](./saksbehandling/02-tildel-oppgave.md) - Automatisk tildeling av neste oppgave
3. [Behandle oppgave](./saksbehandling/03-behandle-oppgave.md) - Vurdere og behandle søknad
4. [Fatte vedtak](./saksbehandling/04-fatte-vedtak.md) - Godkjenne og fatte vedtak

### Behandlingsprosessen
1. [Opprett behandling](./behandling/01-opprett-behandling.md) - Opprette ny behandling fra søknad
2. [Hent behandlingsopplysninger](./behandling/02-hent-opplysninger.md) - Hente data for behandling
3. [Avklare opplysninger](./behandling/03-avklar-opplysninger.md) - Manuell avklaring av opplysninger
4. [Beregn resultat](./behandling/04-beregn-resultat.md) - Beregne dagpengerett og sats

## Event-drevne flyter

### Automatiske prosesser
1. [Behandling fra søknad](./events/01-behandling-fra-soknad.md) - Automatisk opprettelse av behandling
2. [Meldekortberegning](./events/02-meldekort-beregning.md) - Beregning av meldekort/rapportering
3. [Vedtak til utbetaling](./events/03-vedtak-til-utbetaling.md) - Fra vedtak til iverksettelse

## Oversikt over repositories

### Frontend-applikasjoner
- `dp-soknadsdialog` - Søknadsdialog for innbyggere
- `dp-rapportering-frontend` - Rapportering/meldekort for innbyggere
- `dp-saksbehandling-frontend` - Saksbehandlergrensesnitt

### Backend APIs (BFF)
- `dp-soknad` - Søknads-API
- `dp-rapportering` - Rapporterings-API
- `dp-saksbehandling-graphql` - GraphQL API for saksbehandling
- `dp-behandling` - Behandlings-API

### Støttetjenester
- `dp-mellomlagring` - Mellomlagring av data
- `dp-inntekt` - Inntektsopplysninger
- `dp-behov-journalforing` - Journalføring til Joark
- `dp-behov-pdf-generator` - PDF-generering

## Nøkkelhendelser (Events)

### Produserte hendelser
Se individuelle flow-dokumenter for detaljer om hvilke hendelser som produseres hvor.

### Konsumerte hendelser
Se individuelle flow-dokumenter for detaljer om hvilke hendelser som konsumeres hvor.

## Vedlegg
- [Rapid & Rivers arkitektur](./architecture/rapids-rivers.md)
- [Database oversikt](./architecture/databases.md)
- [Event katalog](./architecture/event-catalog.md)
