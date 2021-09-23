---
layout: page
title: Bruk 'ren' json for regelbehov over avro eller serialisering/deserialisering til dataklasser
parent: ADR
nav_order: 3
has_children: false
---

# Bruk 'ren' json for regelbehov over avro eller serialisering/deserialisering til dataklasser

* Status: Accepted
* Deciders: Team Digitale dagpenger
* Date: 2019-02-04

## Context and Problem Statement

Vi må bli enige om en måte å lese/skrive behovdata til kafka på

## Considered Options

* 'Ren' json, der hver tjeneste skriver sine egne funksjoner for å hente ut felter
* Serialsering/deserialisering til felles definerte dataklasser
* Avro

## Decision Outcome

Valget er 'ren' json, der hver tjeneste skriver sine egne funksjoner for å hente ut felter.

### Positive Consequences
* Mindre kobling mellom tjenester
* Kan legge til nye felter uten å endre felles dataklasse/skjema

### Negative consequences
* Mer kode i hver tjeneste for å jobbe på naken json

