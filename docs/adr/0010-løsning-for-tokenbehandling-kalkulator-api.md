---
layout: page
title: Velger å autentisere idporten-tokens selv via ktor sin innebygde auth mekanisme
parent: adr
nav_order: 3
has_children: false
---

# Velger å autentisere idporten-tokens selv via ktor sin innebygde auth mekanisme

* Status: [accepted] <!-- optional -->
* Deciders: [Knut, Atle, Marte]
* Date: [2019-10-31] <!-- optional -->


## Context and Problem Statement

For å kommunisere med dp-oppslag, trengte vi en systembruker til å autentisere oss.  
Da dette gjøres via en token, fikk vi problemer med ktor sin auth, som kun takler en issuer om gangen (per nå).  
Vurderingen var om vi skulle over på token-support biblioteket for å håndtere flere jwt-issuers samtidig,  
eller om vi skulle skrive oss over til å bruke en nyere komponent (dp-graphql) som vi uansett ville migrert til senere.  
dp-graphql bruker x-api-key, som vi uansett ville måttet implementere da vi også skal kommunisere med dp-regel-api  
som også autentiserer via x-api-key.  

## Decision Drivers <!-- optional -->

* Løse autentisering mellom kalkulator-api og idporten samt mellom interne dp-komponenter på en enkel måte

## Considered Options

* Lære seg token-support og implementere dette
* Flytte logikken til å hente aktørid via graphql

## Decision Outcome

Valgte å flytte logikken til å peke på graphql, da dette skulle gjøres i fremtiden likevel,  
og vi omgår helt problemene med flere issuers i ktor-auth biblioteket.

### Positive Consequences <!-- optional -->

* Velger å rette oss mot mot en komponent som ikke skal avskaffes med det første
* Slipper å sette oss inn i flere forskjellige hjelpe-bibliotek

### Negative consequences <!-- optional -->

* Lærer oss ikke token-support biblioteket hvis dette skal brukes i fremtiden
* Lar oss ikke implementere multiple issuers på token autentisering

## Pros and Cons of the Options <!-- optional -->

### Bruke token-support biblioteket

Lære seg token-support biblioteket og implementere det

* Bra, fordi vi får domenekunnskap til biblioteket, og gir oss mulighet til å håndtere multiple issuers.
* Dårlig, fordi det vil ta lengre tid å implementere
* Dårlig, fordi det vil fortsatt være teknisk gjeld å rette seg mot dp-oppslag, som skal vekk til fordel for dp-graphql


## Links <!-- optional -->

* [Token-support biblioteket](https://github.com/navikt/token-support/)
* [dp-kalkulator-api](https://github.com/navikt/dp-kalkulator-api)
* [dp-regel-api](https://github.com/navikt/dp-regel-api)
* [dp-graphql](https://github.com/navikt/dp-graphql)
* [dagpenger-oppslag](https://github.com/navikt/dagpenger-oppslag)
