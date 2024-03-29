---
layout: page
title: 01.07.2019 - Manglende inntekter for LEL1 2019
parent: Postmortems
nav_order: 3
has_children: false
---

# Manglende inntekter for LEL1 2019

**Dato:** 01.07.2019

**Av:** @androa

**Status:** Pågående

**Sammendrag:** Inntekter for enkelte personer kan ikke hentes i Arena.

**Konsekvens:** All saksbehandling av Dagpenger stanset.

**Rotårsaker:** Inntektskomponenten produserte ugyldig JSON med duplikate felter. Vår JSON-parsing tillot ikke det, og feilet.

**Utløsende faktor:** Produksjonssetting av LEL1.

**Løsning:** Fjerne duplikat felt i Inntektskomponenten.

**Påvisning:** Monitorering av loggene i forbindelse med produksjonssettingen.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
| Fjerne duplikat felt i respons fra Inntektskomponenten | feilretting | Jørgen Bjerke | https://jira.adeo.no/browse/REG-4365) |

## Hva lærte vi?

### Hva gikk bra

- Loggmonitorering fungerer.

### Hva gikk dårlig

- Vi mangler automatisk varsling på feil i loggene.
- Vi glemte å følge opp feilen som ble identifisert 29.05.

### Hvor hadde vi flaks

- Det traff kun et subsett av brukerene.

## Tidslinje

29.05.2019

- 09:42: Feilen oppdages under utvikling.
- 10:29: [Issue opprettes i Jira](https://jira.adeo.no/browse/REG-4365) og klassifiseres som C-feil

31.06.2019

- 13:30: Produksjonssetting av LEL1 er ferdig.

01.07.2019

- 07:11: Første feil dukket opp i loggene.
- 07:54: Vi var i gang med feilssøking.
- 07:54: Feil gjenkjent fra utvikling.
- 08:18: Feil identifisert i Inntektskomponenten.
- 08:30: Incidient-kanal opprettet.
- 08:49: Løsning i Inntektskomponenten deployet i t6.
- 09:52: Feilretting verifisert i Inntektskomponenten av Team Registre, og planlagt deploy til produksjon klokken 17:00
- 09:59: Saksbehandlere får beskjed å prioritere andre ting.
- 12:41: Feilretting i Inntektskomponenten deployet til de fleste q/t-miljøer.
- 13:48: Feilårsak verifisert i t4.
- 14:51: Feilretting i Inntektskomponenten er verifisert av testere.
- 15:21: Feilretting i Inntektskomponenten er produksjonssatt.
- 15:29: Verifisert av saksbehandling i produksjon.

## Linker