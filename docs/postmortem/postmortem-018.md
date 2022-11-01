---
layout: page
title: template
parent: Postmortems
nav_order: 3
has_children: false
---

# Ny søknadsdialog for Dagpenger ble lansert for tidlig 

**Dato:**  27.10.2022

**Av:** @geir.andre.lund

**Status:** Løst

**Sammendrag:** 

Dagpengerteamet har en stund jobbet med en ny søknadsdialog denne er prodsatt men ikke lansert. 
Ved utvikling av inngangssider mot søknaden ble "feature togglen" skrudd på i testmiljøet slik at trafikken ble sluppet mot ny søknadssdialog. Denne togglen var konfigurert feil slik at også trafikken i produksjon ble rutet mot ny søknadsdialog.

**Konsekvens:** 

Brukere i ble sluppet inn på en søknadsdialog der ikke all funksjonalitet var klar.  Det ble sendt inn 7 søknader innsendt som må følges opp av NAV arbeid og ytelser (NAY). 

**Rotårsaker:**

Vi benytter [Unleash](https://unleash.nais.io/) som verktøy for feature toggling. I Unleash kan en benytte strategier for når en feature toggle skal være aktiv. I vårt tilfelle hadde vi valg "byCluster" strategi der en kan bruke miljøparameter (feks bare for testmiljøet) for å aktivere toggle'en. Vi hadde tillegg lagt til en strategi "gradualRolloutRandom" der en kan skru på for deler av trafikken (0-100). I forbindelse med test i testmiljøet ble "gradualRolloutRandom" strategien på et tidspunkt erstattet med "default" strategien - denne slo beina under "byCluster" og aktiverte i alle miljøer.  

**Løsning:**

- Skrudde av feature togglen 

**Påvisning:** 

- Så trafikk i produksjon (logger)

## Hva lærte vi?

- Vi lærte at vi har mye av funksjonalitet på plass allerede
- Vi fant en del nye bugs som hadde vært vanskelig å oppdage uten testvariasjonen i produksjon. 
- Det å ha tverrfaglige team er gull når vi skal følge opp de som sendte søknader under perioden. Vi har saksbehandler i teamet og god kontakt med NAY som fulgte opp videre.

### Hva gikk bra

- Søknader ble sendt inn uten tekniske feil

### Hva gikk dårlig

- Funksjonalitet som manglet;
  - beskrivelse og informasjonstekster manglet/mangelfulle i selve søknaden. 
  - spesielt rundt beskrivelse av felter i PDF'er ikke var klare.

## Tidslinje

27.10.2022
- ~ 12:30 inngangsapplikasjon som benyttet feature toggle ble produksjonssatt
- 12:53.34 Feature toggle skrudd på 
- ~ 13:00 Oppdaget aktive logger og påstarte søknader i produksjon
- 13:01.21 Feature toggle skrudd av
- 13:05 -> Oversikt over hvem som som har kommet seg inn i ny søknadssdialog. 
- 14:00 -> Liste med hvem (7 stk) som er berørte oversendt til NAY for videre oppfølgning 

