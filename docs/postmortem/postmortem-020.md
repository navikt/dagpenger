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

**Rotårsaker:** 

Applikasjonen (dp-behov-journalforing) som journalfører søknaden og tilhørende vedlegg begynte å "time ut" mot dokarkiv (applikasjon som journalfører i joark). 
Vi ser derimot at dokarkiv klarte å journalføre enkelte søknader før vi timet. Dette førte til at dp-behov-journalforing trodde at søknad journalposten ikke var opprettet og forsøkte igjen. 
Vi har en applikasjon (dp-mottak) som lytter på opprettede journalposter og sørger for å rute disse til saksbhandlerflate og ferdigstille journalposten, videre gir den beskjed til søknadsdialogen om at søknaden er ferdigstilt som en konsistenssjekk.
Det var denne konsistenssjekken som feilet og førte til at backend for søknadsdialogen gikk ned. 

Backend for søknadsdialogen stod i en tilstand der den ventet på at journalposten var opprettet, men fikk aldri beskjed om det pga timeout problemantikken. Da den fikk beskjed om at journalposten ble ferdigstilt "visste" den ikke at journalposten var opprettet og kom i en tilstandsfeil. Tilstandsfeilen kaster der feil og appliasjonen gikk ned.

Det at backend søknadsdialogen gikk ned førte til at journalføringer av andre søknader stoppet opp. 


**Utløsende faktor:** 

Den 23.05.2023 kl 20:06:19 ser vi i loggene at dp-behov-journalforing begynte å "timet ut" mot dokarkiv. Den 23.05.2023 kl 01:09 ser vi at 1 enkelt søknad ble journalført etter kallet mot dokarkiv hadde timet ut og førte til inkonsistens beskrevet i rotårsak over. 


[Hva gjorde at feilen oppstod?]

**Løsning:** 

[Hva ble løsningen?]

**Påvisning:** 

[Hvordan feilen ble oppdaget?]

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |

## Hva lærte vi?

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

## Tidslinje

## Linker