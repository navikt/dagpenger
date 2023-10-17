---
layout: page
title: Kjekt å vite om våre løsninger
parent: Rutiner ved vakt
nav_order: 3
has_children: false
---

# Kjekt å vite
## Hvorfor restarter Quiz så mye i prod, er noe galt?
Nei, det er ikke noe galt. Grunnen til at dette skjer er at hvis det blir kastet en feil i en quiz-pod så vil podden dø, og det vil bli startet en ny. Dette mønsteret kommer egentlig fra rapids&rivers-biblioteket som vi bruker i mange av våre apper.

## Hvordan gi seg selv midlertidig skrivetilgang til en database i prod?
TODO: Legg til beskrivelse

## Hvordan restarte en pod?

### Alternativ 1
Bruke rollout restart, controlleren vil drepe en pod av gangen og *ReplicaSet* vil sørge for å skalere opp nye podder frem til alle er fornyet. Dette er ideelt fordi applikasjonen ikke vil bli påvirket eller være nede.

>kubectl rollout restart deployment <app-navn> -n teamdagpenger

> ReplicaSet: Et kubernetes-objekt som brukes til å opprettholde et stabilt sett med replikerte pods som kjører i et kluster til enhver tid.


### Alternativ 2
Slette podden. Kubernetes vil automatisk lage en ny pod.

>kubectl delete pod <pod-navn> -n teamdagpenger

### Alternativ 3
Skalere antall replicas til null og deretter tilbake til minst 1:

>kubectl scale deployment <app-navn> --replicas=0 -n teamdagpenger

>kubectl scale deployment <app-navn> --replicas=2 -n teamdagpenger

### Hvordan resende en melding på rapiden?
Hvis en melding feiler og den må resendes manuelt, kan det gjøres via https://dp-saksbehandling.intern.nav.no/internal/rapid.
Husk å starte naisdevice. Meldingene logges i Securelogs (Kibana). Meldingen kan typisk finnes ved å søke på behovId til feilet melding.
Hvis det er lagt inn ekskludering av behovId for feilende melding i applikasjon der feilen oppstår, 
må ekskluderingen fjernes før du resender meldingen.
>private val behovIdSkipSet = emptySet<String>()

Husk å vente til pod'ene er oppe å kjøre igjen etter eventuell deploy, før du resender meldingen.





