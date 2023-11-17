---
layout: page
title: 17.11.2023 - Teknisk oppgradering førte til feil som gjorde at saksbehandlere ikke kunne beregne grunnlag og sats
parent: Postmortems
nav_order: 3
has_children: false
---

# Feil i beregning av dagpenger grunnlag og sats

**Dato:** 17.11.2023

**Av: Giao The Cung, Marius Lauritzen Eriksen og Mona Kjeldsrud**

**Status:** Løst

**Sammendrag:** Saksbehandlere i Arena opplever feil når de skal beregne grunnlag og sats.

**Konsekvens:** Saksbehandlere får ikke saksbehandlet saker.

**Rotårsaker:** Strengere validering av input data.

**Løsning:** Opprettholder validering av input data, men tar høyde for at heltall kan bli angitt som desimaltall. I
slike tilfeller fjernes desimaler, slik at heltallet blir brukt i beregningen.
Dette er i tråd med logikken før endringen som førte til feilen.

[Fiks i dp-regel-sats](https://github.com/navikt/dp-regel-sats/commit/42779cf422ae0ffe3724b0b3c886301df144cf3d)

[Fiks i dp-rege-grunnlag](https://github.com/navikt/dp-regel-sats/commit/42779cf422ae0ffe3724b0b3c886301df144cf3d)

**Påvisning:** Saksbehandlere i Arena oppdaget feilen.

## Hva lærte vi?

I en skjemaløs verden må vi ta høyde for at input data kan være av en annen type enn forventet. Vi må derfor være mer
fleksible i valideringen av input data.
Vi må også ha bedre testdekning av input data.

### Hva gikk bra
Feilen ble fort oppdaget og rettet. 
Validering har blitt bedre som en konsekvens av feilen.

### Hva gikk dårlig
Feilen ble oppdaget i produksjon.

### Hvor hadde vi flaks
At feilen ikke traff sluttbrukere

## Tidslinje

Feil introdusert: 17.11.2023 11:47
Feil oppdaget: 17.11.2023 11:57
Feil rettet: 17.11.2023 13:47


