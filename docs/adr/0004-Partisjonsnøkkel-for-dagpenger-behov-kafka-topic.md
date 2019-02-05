# Partisjonsnøkkel for 'Dagpenger Behov'  Kafka-topic

* Status: Pending
* Deciders: Team Digitale Dagpenger



## Context and Problem Statement

Vi trenger å definere partisjonsnøkkel for 'Dagpenger Behov' Kafka-topic for å kunne håndtere rekkefølge riktig i henhold til prosessering av eventet. 

Hva skal partisjonsnøkkelen være? 

## Decision Drivers
 
* Rekkefølgeproblem
* Annet? 

## Considered Options

* La NAV `aktør id` være partisjonsnøkkel
* La `vedtak id` være partisjonsnøkkel
* En kombinasjon av de over?

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].


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
