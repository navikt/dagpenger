---
layout: page
title: Løsning for teknisk dokumentasjon
parent: ADR
nav_order: 3
has_children: false
---

# Løsning for teknisk dokumentasjon

* Status: [foreslått]
* Beslutningstakere: Utviklere i dagpenger klynga
* Dato: 09.04.2024

Teknisk Historie: 

 For å sikre bedre felles teknisk forståelse for løsningene våre.

## Kontekst og Problembeskrivelse

I dag er dokumentasjonen av løsningene våre veldig fragmentert. Det gjør det vanskelig å få oversikt.

Dette ble bemerket i koderevisjonsrapporten høsten 2023. [Dora rammeverket](https://dora.dev/devops-capabilities/process/documentation-quality/) peker også på at dokumentasjonskvalitet øker produktiviteten.

Krav til løsning for dokumentasjon:
* Versjonskontroll
* Tekst
* Flyttbart format
* Unngå leverandør lås
* Mulighet for visning av bilder
* Mulighet for tegning

Foreslår derfor å ta i bruk [dp-dokumentasjon](https://github.com/navikt/dp-dokumentasjon) for alle teamene. Dette er basert på markdown, drawio og mermaid, med mulighet for videre utvidelser. Vi bruker [Docusaurus](https://docusaurus.io/) som visningslag.

## Beslutningens Pådrivere 

* Bedre oversikt over løsningene våre
* Økt produktivitet

## Vurderte Alternativer

* Confluence
* Mural

