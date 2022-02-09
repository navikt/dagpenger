---
layout: page
title: template
parent: Postmortems
nav_order: 3
has_children: false
---

# Problemer med søke Dagpenger 

**Dato:** 09.02.2022

**Av:** Geir A. Lund

**Status:** Løst

**Sammendrag:** 

Det første Dagpengesøkere treffer når en søker dagpenger er "utslagskriterier" som sjekker opp om en skal fortsette en allerede påstartet søknad. Denne applikasjon (dp-soknad-veileder) kaller et bakenforliggende API i bakkant for søknadsinformasjon. 
Det var dette kallet som feilet med:

```
FetchError: invalid json response body at http://dp-innsyn/soknad?søktFom=2022-02-06 reason: Unexpected end of JSON input
```

Vi var først inn på et spor der vi mistenkte en [endring](https://github.com/navikt/dp-innsyn/commit/ef22de1dd0bdf408d0feba55cd7bfd97c40df575) i det bakenforliggende APIet (dp-innsyn) som ble revertet. Det så tilsynelatende ut til at dette gjorde at kallet over fungerte. Vi gravde videre i endringen i testmiljøet og kunne ikke finne en klar årsaksssammenheng til oppførsel. Etter videre graving mistenkte vi ikke ASCII tegn som urlparameter (`?søktFom=202..`). Det kan virke det er et eller annet som terminerer "requests" mellom podder i klusteret. 

Det korrelerer også sett tidligere incident ([slack tråd](https://nav-it.slack.com/archives/C5KUST8N6/p1637702309447700)).
Sammendrag:

> Tror kanskje har løst denne nå. Problemet er at oppførselen kommer og går.
Det skjer med et sted hvor vi kaller to ulike endepunkt i samme API i parallell. Ofte så lykkes begge, men av og til får den ene 400 Bad Request.
Tailer jeg poden så er det ingen andre containere som sier i fra om noe muffens.
Også prøvd ulike approacher med callId, men det dukker ikke noe utover vår egen app i Kibana.
Begge kallene har samme headers, det er bare ulike endepunkt (soknad vs vedtak).
Av og til dukker det opp en INFO ThreadId(01) outbound: linkerd_app_core::serve: Connection closed error=invalid URI fra linkerd-proxy, men det korrelerer veldig dårlig.
Men det ene kallet hadde søktFom som en query-parameter, og etter jeg bytta det til soktFom så er problemet tilsynelatende borte.
Hva er det som av og til hater ø? :smile:


**Konsekvens:** 

Dagpengersøkere fikk feilmelding under opprettelse av søknad og kunne ikke fortsette.


**Rotårsaker:** 

Ikke ASCII tegn i url. 

**Utløsende faktor:**

Deploy som endret/flyttet hvor poddene levde?

**Løsning:**

Fjernet ikke ASCII tegn i url. (`?søktFom=202..` til `?soktFom=202..`)


**Påvisning:** 

Vi ble gjort oppmerksomme på feil i søknadsdialogen i slack kanalen [#team-dagpenger-vakt](https://nav-it.slack.com/archives/CU268M1AQ/p1644395293590179)

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse                                      |
|---|---|---|------------------------------------------------|
| Finne ut hvorfor vi ikke ble varslet automatisk om feilen | ANALYSE | teamdagpenger | [DAG-129](https://jira.adeo.no/browse/DAG-129) |

## Hva lærte vi?

Ikke bruk andre tegn enn ASCII tegn i URLene. 

### Hva gikk bra

Feilen ble rettet raskt opp i når vi først oppdaget det. (~20min)

### Hva gikk dårlig

Det gikk langt tid før vi oppdaget feilen og hadde heller ingen alarm som oppdaget feilen. Feilen ble oppdaget gjennom brukerhenvendelser. 


### Hvor hadde vi flaks

Forsholdsvis enkel fiks når vi første skjønte feilen. 

## Tidslinje

08.02.2022 20:10 - Deploy av dp-innsyn
08.02.2022 21:10 - Første innslag i loggene (https://logs.adeo.no/goto/6c0a94df6d4e7dbf3ec2bb2126d3fa82)
09.02.2022 09:25 - Henvendelse i #team-dagpenger-alert
09.02.2022 09:34 - Gjør #produksjonshendelser beskjed om kjent feil og forespur melding på NAV.no
09.02.2022 09:55 - Revert av endring i dp-innsyn
09.02.2022 10:00 - 11:30 - Analyse av feil i testmiljø
09.02.2022 ca 12:00 - Fiks av url og deploy av opprinnelig endring i dp-innsyn. Ingen feilmeldinger 


## Linker

- Henvendelse i [#produksjonshendelser](https://nav-it.slack.com/archives/C9P60F4F3/p1644395646540889)
- Logger https://logs.adeo.no/goto/6c0a94df6d4e7dbf3ec2bb2126d3fa82