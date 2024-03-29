---
layout: page
title: 19.08.2020 - Konfigurasjonsfeil i dp-regel-api-arena-adapter som førte til at vurdering av minsteinntekt og beregning av dagpengegrunnlag var utilgjengelig for Arena
parent: Postmortems
nav_order: 3
has_children: false
---

# Konfigurasjonsfeil i dp-regel-api-arena-adapter som førte til at vurdering av minsteinntekt og beregning av dagpengegrunnlag var utilgjengelig for Arena

**Dato:** 19.08.2020

**Av:** Andreas Bergh og Geir André Lund

**Status:** Løst

**Sammendrag:** dp-regel-api-arena-adapter fikk ikke autorisert seg mot dp-regel-api

**Konsekvens:** Saksbehandling gjennom Arena stoppet opp i halvannen time

**Rotårsaker:** Byttet kubernetes-namespace på dp-regel-api-arena-adapter, glemte å oppdatere adresse til security-token-service som gikk mot default namespace

**Utløsende faktor:** Deploy til teamdagpenger-namespcace

**Løsning:** Oppdatere adresse til security-token-service slik den gikk mot default namespace

**Påvisning:** Varslet i en tråd på #produksjonshendelse

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
|  Oppdage error rate i http apiet til  dp-regel-api-arena-adapter via alerts    |   Oppgave   |   Team dagpenger   |   https://github.com/navikt/dagpenger/issues/553  |

## Hva lærte vi?

Dobbel og trippelsjekke adresser når man bytter namespace.
At vi ikke får nok alerts fra dp-regel-api-arena-adapter
Konfigurasjonsrammeverket vårt gjør at vi kan gå direkte inn i podden og sette ny miljøvariabel, trenger ikke hotfixe dette via deploy.

### Hva gikk bra

Feilen var lett å fikse, og ble fikset fort etter vi ble gjort oppmerksom på den

### Hva gikk dårlig

Vi burde blitt oppmerksomme på dette selv – grafanaboardene lyste rødt, men vi fikk ingen alerts. Slik fikk vi ikke varsel før 1 time og 20 minutter etter feilen startet.


### Hvor hadde vi flaks

Feilen var lett å fikse


## Tidslinje

09:55 - Deploy til teamdagpenger-namespace, feil begynner å komme

10:30 - Fjernet app fra default namespace - nå feiler alle kall mot arena-adapter.

10:45 - Tråd i #produksjonshendelser om "Brukerstøtte får inn flere saker ang feil på inntekts komponenten.  Kjent feil?"

11:11 - Bjørn Carlin gjør oss oppmerksom på at vi kan være grunn til feilen

11:17 - Årsak funnet

11:20 – Prøver å deploye hotfix, github actions / nais-deploy gjør at dette tar tid

11:34 – Fiks ute i produksjon

## Linker


Commit med fiks https://github.com/navikt/dp-regel-api-arena-adapter/commit/5c51f5572c491ee415ad88bd209403b29a0549eb
