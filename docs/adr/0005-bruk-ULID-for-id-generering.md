---
layout: page
title: Bruk ULID (Universally Unique Lexicographically Sortable Identifier) som ID-generingsmekanisme
parent: ADR
nav_order: 3
has_children: false
---

# Bruk ULID (Universally Unique Lexicographically Sortable Identifier) som ID-generingsmekanisme

* Status: Accepted
* Deciders: Team Digitale dagpenger
* Date: 2019-01-23

## Context and Problem Statement

Vi må identifiserer entiteter basert på ID'er. (F.eks. regelberegningsid, inntektsid, osv). 


## Considered Options

Disse ID'ene kan være løpenummer eller UUID (eller GUID) eller ULID

* [Løpenummer](https://www.naob.no/ordbok/l%C3%B8penummer) er enkelt å resonnere rundt men kan være uheldig i distribuert verden, der vi kan være avhengig av å gjøre replikering, og hvor vi ikke vil være avhengig av løpenummermekanisme fra en sentral autoritet (database eller lignende)
* [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier) har fordeler over løpenummer at ved at den garanterer unike ID'er uten å være avhengig av en autorative/sentral ID-genererer. Ulempen er at den gir ikke noe informasjon utover 
* [ULID](https://github.com/ulid/spec) kombinerer løpenummer og UUID (på en måte) ved at den gir både et løpenummer (i leksikografisk rekkefølge) og unikhet (uten sentral autoritet=

## Decision Outcome

Valgt ID format er  "[ULID](https://github.com/ulid/spec)", fordi den kombinerer både løpenummer og unikhet på tvers av distribuerte systemer. 

### Positive Consequences 
* Leksikografisk rekkefølge
* Unikhet
* Se flere https://github.com/ulid/spec 

### Negative consequences 

* Verktøystøtte? 
