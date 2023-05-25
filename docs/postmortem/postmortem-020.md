---
layout: page
title: 24.05.2022 - Problemer med søknadsdialogen for Dagpenger
parent: Postmortems
nav_order: 3
has_children: false
---

# Problemer med søknadsdialogen for Dagpenger

**Dato:**

24.05.2022

**Av:**

@geir.andre.lund

**Status:**

Løst

**Sammendrag:**

Feilende journalføring av søknad førte til feil tilstand som igjen førte til at backend til søknadsdialogen gikk ned.

**Konsekvens:**

Degradert søknadsdialog for Dagpenger førte til at:

- Dagpengersøknader kunne ikke bli startet opp og sendt inn.
- Oppdatering av søknader feilet
- Kunne ikke liste ut søknader på Mine dagpenger på nav.no

**Rotårsaker:**

Applikasjonen (dp-behov-journalforing) som journalfører søknaden og tilhørende vedlegg begynte å "time ut" mot
dokarkiv (applikasjon som journalfører i joark).
Vi ser derimot at dokarkiv klarte å journalføre enkelte søknader før vi timet. Dette førte til at dp-behov-journalforing
trodde at søknad journalposten ikke var opprettet og forsøkte igjen.
Vi har en applikasjon (dp-mottak) som lytter på opprettede journalposter og sørger for å rute disse til
saksbehandlerflate og ferdigstille journalposten, videre gir den beskjed til søknadsdialogen-backend (dp-soknad) om at søknaden er
ferdigstilt som en konsistenssjekk. Det var denne konsistenssjekken som feilet og førte til at backend for søknadsdialogen gikk ned.

dp-soknad stod i en tilstand der den ventet på at journalposten var opprettet, men fikk aldri beskjed
om det pga timeout problemantikken. Da den fikk beskjed om at journalposten ble ferdigstilt "visste" den ikke at
journalposten var opprettet og kom i en tilstandsfeil. Tilstandsfeilen kaster der feil og applikasjonen gikk ned. Dette er
per design for å ikke korruptere data. 

Videre førte det til at  journalføringer av andre søknader stoppet opp. dp-behov-journalforing henter søknadsdata 
fra dp-soknad som da var nede.

**Utløsende faktor:**

Den 23.05.2023 kl 20:06:19 ser vi i loggene at dp-behov-journalforing begynte å "timet ut" mot dokarkiv. Den 23.05.2023
kl 01:09 ser vi at 2 enkelte søknad ble journalført etter kallet mot dokarkiv hadde timet ut og førte til inkonsistens
beskrevet i rotårsak over.

**Løsning:**

Kortsiktig: Sørget for at dp-behov-journalforing ikke timet ut for svaret fra dokarkiv ble ferdig.
Langsiktig: Se aksjonspunkter

**Påvisning:**

- Alarmer i #team-dagpenger-alert kanalen 

## Aksjonspunkter

✅ Gjort:
1. Øke timeout-konfig for [dp-behov-journalforing](https://github.com/navikt/dp-behov-journalforing/commit/56f84b5dd7fc7b6f2e1024d2b2931ecfc1349b46) samt la på retry [logikk](https://github.com/navikt/dp-behov-journalforing/commit/b250d09c44c6d188c21eef9f8e501bcd09ded402) 
2. Sørge for at ktor-client sin [validering](https://ktor.io/docs/response-validation.html#default) av http responser er [skrudd på](https://github.com/navikt/dp-behov-journalforing/commit/97d7d1b1cc0017735a63e0b890c2ab0a7a09ad49)
 
🚧 Tiltak:

1. Sørge for å vise riktig status på status.nav.no for [Dagpenger søknadsdialogen](https://status.nav.no/sp/Tjenestedata/5fd70660-ed27-496c-949b-7715510e8038). Den viser informasjon fra gammel søknadsdialogen pt. 
2. Splitte opp dp-soknad i to kjøretidsuavhengige "deployer". En som håndterer søknadsmodellen og en som håndtere journalføringsteg av søknaden, dette for å gjøre det mulig å fortsatt la bruker oppdatere og sende inn søknad selvom vi har problemer med journalføring.
3. Sørge for at ktor-client sin [validering](https://ktor.io/docs/response-validation.html#default) av http responser er skrudd på det vi benytter ktor-client i andre applikasjoner vi eier. 

## Hva lærte vi?

1. Punkt 1 ("The network is reliable") i ["Fallacies of distributed computing"](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing) i høy grad fortsatt er gjeldene og løsningene våre må robustifiseres i henhold. 
2. Feilhåndteringen i systemet fungerer - applikasjonene sørger for at flyten spilte opp igjen når feilen ble rettet.

### Hva gikk bra

- Når feilen ble rettet ble søknader som lå i kø bare prosessert av systemet. Alle søknader som ble sendt inn i degraderingsperioden ble journalført riktig. Ingen informasjonstap eller inkonsistens.  

### Hva gikk dårlig

- Feilen gjorde at brukere ikke kunne påstarte nye søknader eller oppdatere søknader. Dette opplevdes nok som at det noen ganger gikk bra og andre ganger ikke gikk bra.

## Tidslinje

- 23.05.2023 kl 20:06:19 : Første logginnslag om at vi hadde nettverksproblemer mot doarkiv (joark journalføring
- 24.05.2023 kl 01:09 : Timeout mot dokarkiv som gjorde at vi kom i inkonsistens (beskrevet i rotårsaker)
- 24.05.2023 kl 01:10 : dp-soknad begynte å varsle om tilstandsfeil og ble degradert
- 24.05.2023 ca kl 07:25 : "Redteam" i dagpenger oppdaget varsler og starte analyse. Varslet [#produksjonshendelse](https://nav-it.slack.com/archives/C9P60F4F3/p1684906051189099) kanalen. 
- 24.05.2023 ca kl 07:52 : Forsøkte på et plaster for å rette feil slik at søknadsdialogen kom opp igjen.
- 24.05.2023 ca kl 08:00 : Søknadsdialogen kom [opp igjen](https://nav-it.slack.com/archives/C9P60F4F3/p1684907750980949?thread_ts=1684906051.189099&cid=C9P60F4F3). 
- 24.05.2023 ca kl 09:00 : Samme [feilsituasjon kom opp igjen](https://nav-it.slack.com/archives/C9P60F4F3/p1684912956884609?thread_ts=1684906051.189099&cid=C9P60F4F3) og dp-soknad ble degradert
- 24.05.2023 kl 09:00 og utover: Mer feilsøking. Økte timeout og robustifiserte http-klient i dp-behov-journalforing. Vi så da at søknader ble journalført riktig med at det var en stor kø av søknader jobben spiste seg igjennom
- 24.05.2023 kl 10:30 - dp-soknad fikk riktig tilstand og kom opp igjen
- 24.05.2023 kl 10:30 - [Sa ifra at søknadsdialogen var på vei opp igjen i #produksjonshendelser](https://nav-it.slack.com/archives/C9P60F4F3/p1684918655021419?thread_ts=1684906051.189099&cid=C9P60F4F3)
- 24.05.2023 kl 11:15 - [Friskmeldte søknadsdialogen i #produksjonshendelser](https://nav-it.slack.com/archives/C9P60F4F3/p1684918655021419?thread_ts=1684906051.189099&cid=C9P60F4F3)
