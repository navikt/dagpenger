# Tidsavbrudd ved beregning av inngangsvilkår, sats og grunnlag for Dagpenger

**Dato:** 02.01.2020

**Av:** Geir André Lund

**Status:** Løst

**Sammendrag:** 

Tidsavbrudd ved beregning av inngangsvilkår, periode, sats og grunnlag i Arena forårsaket av problemer med å produsere melding mot Kafka. 

**Konsekvens:**

Beregning av inngangsvilkår minsteinntekt, periode, sats og grunnlag for Dagpengesaker i Arena kunne ikke behandles i perioden

**Rotårsaker:** 

Problemer med å produsere melding mot Kafka, da meldingen var over maksimal-størrelse som kan produseres (1000012 bytes - 1Mb). 
Meldingen var stor grunnet en stor inntektsfil for beregningen som igjen førte videre til at dp-datalaster-inntekt (tjenesten som henter inntekt) stoppet opp på denne meldingen og gikk inn i "retry", og som blokkerte nye beregninger fra å beregnes. 

**Utløsende faktor:** 

Stor inntektsfil (> 1MB) hentet fra inntektskomponenten. Løsningen henter inntekt for de siste 36 måneder og avhenging av hvordan arbeidsgiver rapporter inntekt kan denne bli veldig stor (https://nav-it.slack.com/archives/CA4KR8GRJ/p1578046967063500?thread_ts=1578045032.057700&cid=CA4KR8GRJ)


**Løsning:** [Hva ble løsningen?]

**Påvisning:** [Hvordan feilen ble oppdaget?]

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |

## Hva lærte vi?

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

## Tidslinje

## Linker