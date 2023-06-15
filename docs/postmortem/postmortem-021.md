---
layout: page
title: 13.06.2023 - Søknadsdialogen feil i tekstfelt gir dårlig brukeropplevelse
parent: Postmortems
nav_order: 3
has_children: false
---

# Søknadsdialogen feil i tekstfelt gir dårlig brukeropplevelse

**Dato:** 13.06.2023

**Av:** Knut M Riise & Rebecca Gjerstad

**Status:** Pågående

**Sammendrag:**
Tekst forsvinner når bruker skriver inn i samtlige tekstfelt i søknadsdialogen. Identifikator er en tidligere fiks for å garantere riktig state fra backend i faktum felt. Problemet oppstår når man larger tekst mens brukeren skriver i tekstfelt. Dette skjer ved at vi har en debounce hvert 500 millisekund, men at vi allikevel lagrer hvert 2000 millisekund selv om bruker fortsatt skriver.

**Konsekvens:**
Bruker mister bokstaver ca hvert andre sekund, men hvis hen skriver en lengre tekst i tekstfelt i søknadsdialogen og må dermed rette opp skriften relativt mange ganger før teksten bruker prøver å skrive blir riktig.

**Rotårsaker:**
Rotårsak er en sjekk for å forhindre en state i frontend ikke divergerer fra backend når man lagrer et svar. Dette er fordi svaret man får tilbake fra backend vil overskrive tekst har kommet etter den automatiske lagreringen startet og før responsen fra backend har mottatt.

**Utløsende faktor:**
[Github commit](https://github.com/navikt/dp-soknadsdialog/commit/e92fa554b0e95f1197691e5c9d8d7edc2b0b5f82#diff-97cc8c910637ad138c7612dd6278176de7cd32fea4f19a7bba83a7ae486d7463R44). En fiks tiltenkt andre spørsmålstyper i skjemaet for å forhindre at vi ikke viser feil svar i for eksempel radioknapper eller andre valg typer. På en generell basis, implementerte man fiksen på alle svar typer uten å ta hensyn til at tekstfelt ville få en uheldig virkning.

**Løsning:**
TODO

**Påvisning:**
[Jira](https://jira.adeo.no/browse/FAGSYSTEM-281133). Bruker innmeldt feil vanskeligheter å svare i større tekstfelt nærmere graving viste at feil skjer i alle tekstfelt, men det vil inntreffe færre ganger jo mindre tekstfeltene er.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --------- |

## Hva lærte vi?

Vanskelig å oppdage lokalt når man ikke har delay. Fiksen fungerer bedre på felter som ikke har lengre tekstfelter.

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

## Tidslinje

## Linker
