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

Dagpengerteamet har en stund jobbet med en ny søknadsdialog, denne er prodsatt men ikke lansert. 
Ved utvikling av inngangssider mot søknaden ble "feature togglen" skrudd på i testmiljøet slik at trafikken ble sluppet mot ny søknadssdialog. Denne togglen var konfigurert feil slik at også trafikken i produksjon ble rutet mot ny søknadsdialog. 

**Konsekvens:** 

Brukere i prod ble sluppet inn på en søknadsdialog der ikke all funksjonalitet var klar.  Det ble sendt inn 7 søknader innsendt som må følges opp av NAY. 


**Rotårsaker:** 



**Utløsende faktor:** [Hva gjorde at feilen oppstod?]

**Løsning:** [Hva ble løsningen?]

**Påvisning:** [Hvordan feilen ble oppdaget?]



## Hva lærte vi?

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

## Tidslinje

## Linker