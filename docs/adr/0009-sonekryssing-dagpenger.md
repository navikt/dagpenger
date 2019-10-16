# Sonekryssing for dagpengeapplikasjoner

* Status: [accepted]
* Deciders: [Knut, Atle, Marte, Geir André]
* Date: [2019-09-14] 


## Context and Problem Statement

Gitt at vi har valgt å løse kommunikasjon mellom apper i sbs og regel api (pluss aktøroppslag) i fss via sonekryssing. Hva er den beste måten å sonekrysse på?

## Decision Drivers <!-- optional -->

* Hvor skal sonekryssingen håndteres?
* Hvilken sonekryssing skal vi kopiere fra navikt?
* Hvordan skal det konfigureres?
* Skal vi bygge noe fra bunnen av?
* Hvilken løsning kan enklest endres til GCP og mesh?

## Considered Options

* Helse-reverse-proxy
* syfoproxy
* bygge noe selv

## Decision Outcome

Valgte: "helse-reverse-proxy", fordi: løsningen og gjør at vi har større kontroll over hvordan de interne fss applikasjonene til dagpenger eksponeres (bl.a regelapi)
Dette er en reverse proxy i fss, som tar imot forespørsler fra api i sbs, og som i teorien videresender forespørsler og svar til regel-api og oppslag

### Positive Consequences <!-- optional -->

* Vi kontrollerer tilgang til dp-regel-api og dp-oppslag 
* Blir i teorien enklere å endre når vi endrer til mesh
* God dokumentasjon på config-registreringer i fasit og mot api-gateway
* enkelt å endre hvis vi skal skifte fra oppslag til graphql komponenten

### Negative consequences <!-- optional -->

* litt mer config
* appen inneholder mer logikk

## Pros and Cons of the Options <!-- optional -->

### syfoproxy

ligger i sbs, og konfigureres til å replikere seg selv som en egen proxy for hver tjeneste man skal snakke med i fss

* Bra, fordi den inneholder nesten null logikk, kun nginx proxy og konfigurasjon
* Dårlig, fordi den krever at samtlige apper som skal eksponeres i fss må registreres i api-gateway
* Dårlig fordi den eksponerer regel-api og oppslag hvis noe går galt med api-gateway
* Dårlig fordi api-gateway må konfigureres og registreres på nytt hvis vi flytter aktørløsning fra oppslag til graphql

### bygge noe selv

f.eks en nginx-reverse-proxy ala syfoproxy, bare i fss

* Bra, fordi den treffer de beste punktene fra syfoproxy og helse-reverse-proxy
* Dårlig, fordi det er merarbeid og bygge fra bunnen av, og vi treffer garantert på noen hindringer vi ikke har tenkt på, de andre løsningene er bevist at fungerer.

## Links <!-- optional -->

* Viderebygging av [ADR-0008](0008-kommunikasjon-mellom-sbs-og-regel-api.md)

