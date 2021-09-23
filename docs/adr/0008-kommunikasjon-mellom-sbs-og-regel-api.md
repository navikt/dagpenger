---
layout: page
title: Kommunikasjon mellom applikasjon i sbs og regel-api
parent: adr
nav_order: 3
has_children: false
---


# Kommunikasjon mellom applikasjon i sbs og regel-api 

* Status: pending
* Deciders: Team Dagpenger
* Date: 2019-10-06 

## Context and Problem Statement

Vår nye dagpengekalkulator er en front-end som skal leve i sbs. Den trenger å snakke med dp-regel-api i fss.
I fremtiden vil vi også få flere ting som lever i sbs, så vi må finne en fornuftig måte å kommunisere 

## Considered Options

* Sonekryssing 
* Deploye regel-api i begge soner
* Bruke kafka som regel-api-endepunkt 
* … 

## Pros and Cons of the Options 

### Sonekryssing 

#### Cons

- Det er komplisert å sette opp. Riktignok en one time job: Se https://confluence.adeo.no/display/AR/Sonekrysning

#### Pros

- Har blitt gjort før av andre i nav

### Deploye regel-api i begge soner

#### Cons
- Mere å monitorere
- Credentials til DB må legges inn i Vault
- Upløyd mark

#### Pros

- Kan forholde seg til samme API


### Bruke kafka som regel-api-endepunkt 


#### Cons

- Må duplisere logikk som allerede er implementert i dp-regel-api
"Dingsen" som leser til og fra kafka og returnerer resultater må ha state (ref over egentlig)

#### Pros

## Decision Outcome

Vi har valgt å sonekrysse, fordi dette allerede er gjort av blant annet helse i nav.
Løsningen vi har valgt vil uansett bare vare frem til vi en gang kan benytte oss av service mesh.