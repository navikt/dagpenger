---
layout: page
title: template
parent: Postmortems
nav_order: 3
has_children: false
---

# Teknisk oppgradering førte til feil i mapping i grunnlagsberegning

**Dato:** 15.11.2023

**Av:**
Marius Lauritzen Eriksen, Mona Kjeldsrud, Giao The Cung

**Status:** Løst

**Sammendrag:**
Ved en større teknisk oppgradering, så introduserte vi en feil. Verdien for fangst og fiske fikk samme verdi som avtjent
verneplikt.

**Konsekvens:**
Ingen konsekvens.

Dette vet vi pga. at Mona sjekket i Arena databasen. Alle vedtak hvor vernepliktregel skal brukes for grunnlaget som er
beregnet i perioden med feil
(14.11.2023, ca 10:47 - 15.11.2023, ca 14:24) har fått beregningsgrunnlaget til verneplikt og ikke fått inntekter fra
fangst og fiske.

**Rotårsaker:**
Copy/paste feil ved en repetativ oppgave. Uthenting av mange lignende meldingsfelter i JSON. Testene plukket ikke opp
dette desverre.

**Utløsende faktor:**
En større teknisk oppgradering med behov for omskriving av mapping mellom json melding og beregningsfakta til
grunnlagsbergning.

Koden som [innførte feilen](https://github.com/navikt/dp-regel-grunnlag/commit/48f9f9c954ef8ebd4e2b11b0f839b946c5d3dadf)

**Løsning:**
Løsningen ble å mappe riktig. I dette tilfellet hente ut verdien av fangst og fiske istedenfor avtjent verneplikt

Koden som [fikset feilen](https://github.com/navikt/dp-regel-grunnlag/commit/6a06134a86663a397a40a96661fb3edb1b886f6a)

**Påvisning:**
Vi skulle gjenbruke mappingen fra json til fangst og fiske, og så at vi hentet ut verdien til avtjent verneplikt
istedenfor fangst og fiske

## Aksjonspunkter
Skrive mer detaljerte tester på mapping mellom json og fakta

## Hva lærte vi?
Testene må være detaljerte nok. Teknisk oppgradering kan være risikabelt

### Hva gikk bra

Feilen ble fort oppdaget


### Hvor hadde vi flaks

At regelen for fangst og fiske var utgått (01.01.2022), og at vi tilfeldigvis skulle gjenbruke den aktuelle mappingen
for fangst og fiske.

## Tidslinje

Feil introdusert: 14.11.2023 10:47
Feil oppdaget: 15.11.2023 14:20
Feil rettet: 15.11.2023 14:24
