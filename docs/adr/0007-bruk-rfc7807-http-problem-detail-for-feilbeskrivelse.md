---
layout: page
title: Bruk rfc7807 "http problem detail" spesifikasjon til å lage strukturelle feilbeskrivelser i HTTP APIer og KAFKA meldinger
parent: ADR
nav_order: 3
has_children: false
---

# Bruk rfc7807 "http problem detail" spesifikasjon til å lage strukturelle feilbeskrivelser i HTTP APIer og KAFKA meldinger

* Status: pending
* Deciders: Team dagpenger
* Date: 2019-03-20

## Context and Problem Statement

Feilemldinger og informasjon rundt feil bør kunne reageres på. For å få til det bør vi ha en strukturell måte å beskrive feilmeldinger på, der feilmeldinger som kan tolkes både maskinellt og menneskelig. 
 
## Considered Options

* Egenskrevet feilmelding
* [RFC7807](https://tools.ietf.org/html/rfc7807)  

"Egenskrevet feilmelding" - vi definerer en struktur til å definere feilmeldinger på. 

RFC7807 - Er en standard for å formidle maskinlesbare detaljer om feil. Det er en ganske enkel standard som definerer type, tittel, detaljer på problemet. Et eksempel: (fra https://tools.ietf.org/html/rfc7807)

```json

   {
    "type": "https://example.com/probs/out-of-credit",
    "title": "You do not have enough credit.",
    "detail": "Your current balance is 30, but that costs 50.",
    "instance": "/account/12345/msgs/abc",
    "balance": 30,
    "accounts": ["/account/12345",
                 "/account/67890"]
   }
```
type, title, detail og instance er obligatoriske og en kan legge til andre felter. 

Kan eksempelvis uttrykkes noe sånt i Kotlin: 

```kotlin

data class Error (
    val type: URI = URI.create("about:blank"),
    val title: String,
    val status: Int,
    val detail: String? = null,
    val instance: URI = URI.create("about:blank")
)
```

Tanken er at dette også kan brukes i Kafka meldinger (på "Packet" i River-strømmen)

## Decision Outcome

Valgt: "[RFC7807](https://tools.ietf.org/html/rfc7807) " fordi: 

- den definerer en standard for å kommunisere feil på
- kan kategorisere feil 
- kan brukes som en kilde ikke bare til å kommunisere feilen, men også en kilde til å kommunisere mulige løsnigner til feil 


