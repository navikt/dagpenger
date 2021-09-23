---
layout: page
title: Hvordan skal vi fjerne lokalt kodeverk i soknaddagpenger-server
parent: adr
nav_order: 3
has_children: false
---

# Hvordan skal vi fjerne lokalt kodeverk i soknaddagpenger-server

* Status: pending
* Deciders: @teamdagpenger
* Date: 2019-09-17

## Context and Problem Statement

Enonic CMS skal oppgraderes til Enonic XP og den gamle instansen skal skrus av. I dag ligger "lokalt kodeverk" i Enonic, en liste med skjema og metadata om de. Dette pakkes inn i Maven-pakken `no.nav.sbl.dialogarena:common-lokalt-kodeverk` som publiseres og brukes i `soknaddagpenger-server`, `henvendelse` og `dialogstyring`. 

De samme metadataene er nå tilgjengelig fra en egen tjeneste som baserer seg på Sanity og eksponerer et API for å hente metadata.

I tillegg gjøres det en endring i `henvendelse` og `dialogstyring` hvor vi setter `NAV skjema-id og tittel, istedenfor `netsid`. I dag er det `ruting` som leser `netsid` og setter inn NAV skjema-id` og tittel.

## Decision Drivers 

* Endringsevne - hvor ofte trenger vi å endre metadata
* Tid brukt - det er ikke noe vi ønsker å prioritere nå
* Cost of Delay - det hindrer oss i å gjøre ting vi helst vil
* Kompetanse - vi bør lære mer om `soknaddagpenger-server` og verdikjeden

## Considered Options

1. Ikke endre noe
2. Trekke ut innholdet i den delte pakka og bygge det inn i `soknaddagpenger-server`
3. Hente metadata fra skjemaveiviser run-time
4. Hente metadata fra skjemaveiviser build-time
5. Ikke endre noe og løse dette med nytt innløp
6. Betale noen andre til å løse det

## Decision Outcome

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* …

### Negative consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, …]
* …

## Pros and Cons of the Options 

### Ikke endre noe

Vi kan fortsette uten å endre noe, pakken vil fortsatt eksistere.

* Bra, fordi vi ikke trenger å bruke tid på endringen
* Dårlig, fordi vi står veldig fast om noe må endres

### Trekke ut innholdet i den delte pakka og bygge det inn i `soknaddagpenger-server`

Flytte innholdet i `no.nav.sbl.dialogarena:common-lokalt-kodeverk` inn i `soknaddagpenger-server` for å gjøre endringer direkte i applikasjonen.

* Bra, fordi vi bruker mindre tid på endringen
* Bra, fordi den lar oss gjøre evt. korrigeringer

### Hente metadata fra skjemaveiviser run-time

* Bra, fordi det blir gjort "riktig"
* Bra, fordi vi lører om `serverdagpenger-server`
* Dårlig, fordi vi må bruke mye tid på endringen
* Dårlig, fordi vi får en kjøretidsavhengighet mot `skjemaveiviser`

### Hente metadata fra skjemaveiviser build-time

* Bra, fordi det blir gjort "riktig"
* Bra, fordi vi lører om `serverdagpenger-server`
* Bra, fordi vi ikke får en kjøretidsavhengighet mot `skjemaveiviser`
* Dårlig, fordi vi må bruke mye tid på endringen

### Ikke endre noe og løse dette med nytt innløp

Usikker på om dette i det hele tatt er et alternativ.

### Betale noen andre til å løse det

Sjekke om Noen Andre kan løse dette.

* Bra, fordi vi ikke trenger å bruke tid på endringen
* Bra, fordi det blir gjort "riktig"
* Dårlig, fordi vi ikke lærer noe om `soknaddagpenger-server`

## Links 

* Bakgrunn for [løsrivelse av lokalt kodeverk](https://confluence.adeo.no/pages/viewpage.action?pageId=322899701)
