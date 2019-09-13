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

### Deploye regel-api i begge soner

### Bruke kafka som regel-api-endepunkt 
