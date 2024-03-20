---
layout: page
tittel: Navnekonvensjon for ID-er
forelder: ADR
nav_order: 3
har_barn: false
---

# Navnekonvensjon for ID-er

* Status: [foreslått]
* Beslutningstakere: Utviklere i dagpenger klynga
* Dato: 21.02.2024

Teknisk Historie: 

For å sikre konsistens og forbedre lesbarheten i koden, foreslår vi å innføre en navnekonvensjon for identifikatorer (ID-er).

## Kontekst og Problembeskrivelse

Vi har ingen konsistent bruk navnekonvensjon for sentrale ID-er, eksempler på dette er: 
- `søknad_uuid`
- `søknadsId`
- `søknadId`
- `søknadID`
- `urn:soknadid:1234`

Det skaper en del forvirring og gjør det vanskelig å forstå hva som er hva og skaper utfordringer i sporing på tvers av systemer.

Forslår derfor at vi innfører en navnekonvensjon for ID-er. Forslaget er at vi bruker 

*`<kontekst>Id`* for ID-er, eksempler

- `søknadId`
- `vedtakId`
- `oppgaveId`
- `behandlingId`

Og for personer bruker vi: 

- `ident` for fødselsnummer og d-nummer 

## Beslutningens Pådrivere 

* Konsistens på tvers av kodebasen
* Forbedre lesbarhet
* Forbedre sporing på tvers av systemer

## Vurderte Alternativer

* Ingen navnekonvensjon for ID-er blir fort kaos
* Med genetiv-s f.eks. `søknadsId`, `vedtaksId`, `oppgavesId`, `behandlingsId` men det blir for mye s (stemt ned https://nav-it.slack.com/archives/CCP6QNBSN/p1707814178959489 )

