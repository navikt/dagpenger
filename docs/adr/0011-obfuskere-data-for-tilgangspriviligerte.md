---
layout: page
title: Obfuskere data for tilgangspriviligerte
parent: adr
nav_order: 3
has_children: false
---

# Obfuskere data for tilgangspriviligerte

* Status: [accepted]
* Deciders: [Atle, Andreas, Marte, Geir André] 
* Date: [2019-12-09]

## Context and Problem Statement

I dag trenger arena å vite behandlende enhet for å opprette oppgaver. Dette er uheldig da dette er sensitivt mtp. kode 6/7.
Vi legger behandlende enhet på kafka i packeten.

## Considered Options

* Kryptere behandende enhet
* Kryptere hele meldingen
* La NAVs nåværende sikkerhet være nok

## Decision Outcome

Vi valgte å la NAVs nåværende sikkerhet være nok, og heller bygge en sikrere arkitektur når vi fåt tatt over Arenas og BRUTs funksjoner.
Blant annet ved å la de som behandler selv finne ut behandlende enhet det skal til.
Etter at det ikke ble mulig for utviklere å få tilgang til produksjonspassord i vault er det ikke mulig for oss heller å se dataen.
