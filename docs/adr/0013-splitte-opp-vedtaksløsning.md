---
layout: page
title: Arkitektur for vedtaksløsningen (WIP)
parent: ADR
nav_order: 3
has_children: false
---

# Work in progress!

# Arkitektur for vedtaksløsningen

* Status: Påbegynt
* Deciders: Geir André, Tonje, Frode og Marius
* Date: 18-08-2023

Technical Story: [description | ticket/issue URL]

## Bakgrunn: 
dp-vedtak har litt for mange ansvarsområder, som gjør at vi har 
lyst til å splitte opp denne i mindre biter.

## Noen problemer vi har observert:
- Kommunikasjon med ikke-teknologer er en utfordring
- Kompleksiteten er høy
- Stor kognitiv last
- Dagpenger krever veldig stor endringsdyktighet (ref koronaperioden), 
og dagens løsning mener vi ikke tilfredsstiller dette behovet
- Lite skalerbart for flere utviklingsteam
- Vanskelig for nye å komme seg inn i prosjektet

## Beslutningsdrivere

- Det skal være enkelt å forstå hvilke deler av løsningen som gjør hva
- Det skal være enkelt å kommunisere med ikke-teknologer rundt løsningen 
- Det skal være enkelt å sette seg inn i løsningen
- Det skal være trygt og enkelt å gjøre endringer i løsningen

## Considered Options

1. Splitte opp dp-vedtak i mindre tjenester som løser subdomener i verdikjeden (f.eks. løpende beregning)
2. Fortsette som i dag, med en vedtaksmonolitt

## Decision Outcome

Avventer forankring i klynga, men vi heller mot alternativ 1.

### Positive Consequences 
- Arkitekturen speiler forretningen bedre
- Mindre tjenester gjør at de blir enklere å endre
- Mindre tjenester minsker risiko for feil
- Stort potensiale i dataflyten (f.eks omfang av bruk av forskjellige regler og utfall)
- Kan stimulere til økt kommunikasjon og informasjonsflyt mellom teamene
- Nærmere teknisk retning (Publisere hendelser)

### Negative consequences <!-- optional -->
- Dataflyten kan være vanskelig å følge
- Flere tjenester som må:
  - Vedlikeholdes
  - Monitoreres


* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### [option 1]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### [option 2]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

### [option 3]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* … <!-- numbers of pros and cons can vary -->

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* … <!-- numbers of links can vary -->
