---
layout: page
title: 26.04.2023 - Søknad og ettersending for dagpenger var midlertidig utilgjengelig
parent: Postmortems
nav_order: 3
has_children: false
---

# Søknad og ettersending for dagpenger var midlertidig utilgjengelig

**Dato:** 26.04.2023

**Av:** Knut M Riise

**Status:** Løst

**Sammendrag:** 
Grunnet modifikasjoner av ingress konfigurasjon under lansering av ny produktside for dagpenger, 
var vi litt for aggressive og tok over url'er som skulle gått til side for 
søknadsdialog og ettersending/opplastning av vedlegg til dagpenger

**Konsekvens:** 
Søknadsdialogen og ettersending av dokumentasjon for dagpenger var utilgjengelig i perioden fra 12:30 til 14:00 26. april 2023.

**Rotårsaker:**
Aggresiv bruk av regex for konfigurasjon av ingress på nais platformen.

**Utløsende faktor:** [Hva gjorde at feilen oppstod?]

**Løsning:** Spesifisere tre ingresser i konfigurasjon fremfor å stjele **alt** etter nav.no/dagpenger

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