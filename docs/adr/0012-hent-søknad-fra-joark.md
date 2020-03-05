# Hent søknad fra Joark

* Status: [accepted | superseeded by [ADR-0005](0005-example.md) | deprecated | …] <!-- optional -->
* Deciders: [list everyone involved in the decision] <!-- optional -->
* Date: [YYYY-MM-DD when the decision was last updated] <!-- optional -->

## Context and Problem Statement

I dag har vi kun strukturert data fra søknaden i form av en JSON i Joark.

For å kunne begynne automatisk saksbehandling må vi ha tilgang til dataen i et strukturert format.

## Decision Drivers 

* Det må være enkelt å få tilgang til enkelte datapunkter, f.eks. avtjent verneplikt
* Oppetid og svartid hos Joark

## Considered Options

* Hente JSON fra Joark ved behov
* Hente JSON fra Joark på ny journalpost og lagre i database
* Hente JSON fra Joark på ny journalpost og publisere på Kafka

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options <!-- optional -->

### Hente JSON fra Joark ved behov

Vi bygger en tjeneste som kan hente JSON direkte fra Joark og hente ut datapunktene vi trenger.

![Illustrasjon av alternativ 1](docs/images/0012-alt1.png)

* Bra, fordi vår tjeneste stateless
* Dårlig, fordi vi er avhenging av Joark i runtime
* Dårlig, fordi vi skaper mye last på Joark

### Hente JSON fra Joark på ny journalpost og lagre i database

Vi henter JSON når det kommer inn nye journalposter og lagrer den i en database.

I tillegg bygger vi en tjeneste som eksponerer data via et API, eller svarer på Behov fra Kafka.

![Illustrasjon av alternativ 1](docs/images/0012-alt2.png)

* Bra, fordi vi får vår egen kopi av søknaden 
* Dårlig, fordi vi ikke kan reagere på data via Kafka
* Dårlig, fordi vi er avhenging av at Joark er oppe for å kunne fortsette

### Hente JSON fra Joark på ny journalpost og publisere på Kafka

Vi henter JSON når det kommer inn nye journalposter og publiserer den på Kafka som en egen hendelse.

I tillegg lager vi en tjeneste som konsumerer topicen og eksponerer data via et API, eller svarer på Behov fra Kafka.

![Illustrasjon av alternativ 1](docs/images/0012-alt3.png)

* Bra, fordi vi får vår egen kopi av søknaden
* Bra, fordi vi kan reagere direkte på nye søknader
* Bra, fordi vi ikke har noen runtime avhengighet på Joark
