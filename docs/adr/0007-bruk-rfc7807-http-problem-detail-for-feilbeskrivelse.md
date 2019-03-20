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

Tanken er at dette også kan brukes i Kafka meldinger (på "Packet")

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative consequences <!-- optional -->

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
