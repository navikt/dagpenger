---
layout: page
title: Bruk UUID versjon 7 til ID generering
parent: ADR
nav_order: 3
has_children: false
---

# Bruk UUID versjon 7 til ID generering

* Status: proposed
* Deciders: Utviklere i dagpenger klynga? PoA?
* Date: 13.02.2024

## Context and Problem Statement

Vi må identifiserer entiteter basert på ID'er. (F.eks. behandlingId, vedtakId, oppgaveId, osv). 

## Decision Drivers 
* Ikke avhengig av at biblioteket er tilgjengelig på alle plattformer 
* IDen skal kunne leses av "alle" språk på alle plattformer

## Considered Options

* [Løpenummer](https://www.naob.no/ordbok/l%C3%B8penummer) er enkelt å resonnere rundt men kan være uheldig i distribuert verden, der vi kan være avhengig av å gjøre replikering, og hvor vi ikke vil være avhengig av løpenummermekanisme fra en sentral autoritet (database eller lignende)
* [UUID v4](https://en.wikipedia.org/wiki/Universally_unique_identifier) version 4 har fordeler over løpenummer at ved at den garanterer unike ID'er uten å være avhengig av en autorative/sentral ID-genererer. Ulempen er at den gir ikke noe informasjon utover identifikasjon og at den ikke er sorterbar.
* [ULID](https://github.com/ulid/spec) kombinerer løpenummer og UUID (på en måte) ved at den gir både et løpenummer (i leksikografisk rekkefølge) og unikhet (uten sentral autoritet). Ulempen er an trenger et bibliotek for å generere og tolke ULID 
* [ULID v7](https://www.ietf.org/archive/id/draft-peabody-dispatch-new-uuid-format-04.html#name-uuid-version-7) kombinerer løpenummer i for av tid (time-ordered, Epoch timestamp), og UUID ved at den gir både et løpenummer (i leksikografisk rekkefølge) og unikhet (uten sentral autoritet). Fordelen er at den kan leses som en "vanlig" UUID (feks `java.util.UUID`), og at den er en standard. Ulempen er at den ikke er implementert i noen språk (?) uten bibliotek enda. Den som lager UUIDen må ha et bibliotek.  

Alle valgene over kan leses som "string" i alle språk. 

## Decision Outcome

Preferert ID format er "[UUID v7](https://www.ietf.org/archive/id/draft-peabody-dispatch-new-uuid-format-04.html#name-uuid-version-7) ", fordi den kombinerer både løpenummer og unikhet på tvers av distribuerte systemer, og kan leses av alle språk (det er fortsatt bare en UUID).

### Positive Consequences 

* Leksikografisk rekkefølge
* Unikhet
* Kan leses av "alle" språk
* Tid er en del av UUIDen

### Negative consequences 

* UUID v7 er ikke implementert i noen språk uten bibliotek enda. Den som lager UUIDen må ha et bibliotek.
* Forholdvis nytt forslag, kan være uferdig?
* Verktøystøtte?

### Eksempel på UUID v7 i Kotlin

Vi trenger et bibliotek for å generere UUID v7. 

Et av bibliotekene for UUID v7 generering i Kotlin er [Java Uuid Generator (JUG)](https://github.com/cowtowncoder/java-uuid-generator).

```gradle
implementation("com.fasterxml.uuid:java-uuid-generator:<VERSJON>")
```

```kotlin
object UUIDv7 {
    private val idGenerator = Generators.timeBasedEpochGenerator()
    fun nyUuid(): UUID = idGenerator.generate()
}

fun main() {
    val behandling = Behandling(id = UUIDv7.nyUuid())
}
```
