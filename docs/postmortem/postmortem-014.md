---
layout: page
title: 15.05.2020 - Allerede innsendte søknader ble forsøkt migrert til nyere versjon da bruker prøvde å ettersende dokumenter
parent: Postmortems
nav_order: 3
has_children: false
---

# Allerede innsendte søknader ble forsøkt migrert til nyere versjon da bruker prøvde å ettersende dokumenter

**Dato:** [15.05.2020]

**Av:** Knut M Riise

**Status:** [Løst]

**Sammendrag:**
Oppgradering av søknadsdialogen for mulighet til å migrere søknader, slik at man kunne legge på oppdaterte koronafelter i søknad uten å slette samtlige søknader, gjorde ved et uhell slik at ferdig innsendte søknader også ble migrert til ny versjon da brukere ønsket å ettersende dokumenter på en allerede innsendt søknad. Dette førte til et kresj, da den migrerte innsendte søknaden feilet valideringen, gitt at de nye feltene ikke var fyllt ut.

**Konsekvens:** Brukere hadde ikke mulighet til å ettersende dokumenter på allerede innsendte søknader i tidsrommet mellom kl 11 og kl 13 den 15. mai 2020

**Rotårsaker:** Utviklerene var ikke klar over at også ettersendingsmodulen lå inne i prosjektet hvor vi migrerte søknadene, og at migrering ble kjørt på søknader som ble hentet opp av databasen uansett om søknaden allerede var sendt inn eller ikke. Allerede

**Utløsende faktor:** Feilen oppstod ved at vi ikke filtrerte vekk allerede innsendte søknader i migreringslogikken. Utløst av at bruker ønsker å starte en ettersendelse av dokumenter, som gjør at en allerede innsendt søknad blir åpnet og lest av server.

**Løsning:** Filtrere vekk allerede innsendte søknader fra migreringslogikken

**Påvisning:** Rapporter om at man ikke kunne laste opp ettersendelser ble meldt via JIRA(https://jira.adeo.no/browse/FAGSYSTEM-111142) bekreftet mistanken om at vi hadde en feil. Utviklerene holdt allerede på med debugging av feil i kibana uten å finne årsak før JIRA henvendelsen ble meldt inn.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| Filtrere ut søknader uten versjonsnummer | bugfix | Team Dagpenger | https://github.com/navikt/dp-soknad-server/commit/4ce8d5e6464eadd6b5ba406a3becc062db1ac402 |
| ------ | ---- | ---- | --- |
| ------ | ---- | ---- | --- |

## Hva lærte vi?

Vi var på forhånd klar over at dette var en risikabel oppgradering, og selv med grundig testing greide vi ikke fange opp problemet med ettersendelser. Heldigvis var vi på utkikk etter feil og hadde satt av god tid til analyse etter oppgraderingen ble rullet ut på morgenen

### Hva gikk bra

JIRA innmelding, samt loggovervåkning

### Hva gikk dårlig

Loggene greide ikke påpeke hvorfor vi fikk problem med innsending, eller at det var ettersending

### Hvor hadde vi flaks

JIRA sak ble meldt inn veldig raskt, vanligvis tar det 2-3 dager før slike saker når oss

## Tidslinje

kl 11:00? oppgraderingen blir rullet ut
kl 11:15 feil begynner å vises i log, debugging starter
kl 12:07 JIRA sak blir opprettet og sendt til teamDagpenger
kl 12:15 Rotårsak blir funnet
kl 12:45 løsning blir rullet ut
kl 13:00? systemene fungerer igjen, brukere som tidligere prøvde å ettersende dokumenter greier å ettersende igjen

## Linker

original oppgradering: https://github.com/navikt/dp-soknad-server/pull/43
bugfix: https://github.com/navikt/dp-soknad-server/pull/59
Jira sak: https://jira.adeo.no/browse/FAGSYSTEM-111142
