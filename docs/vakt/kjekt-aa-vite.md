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

## Mottok aldri løsning for `<et eller annet behov>`
TODO: Legg til beskrivelse

# Manuelle tiltak ved kjente feilsituasjoner
Slettejobben stopper pga et event som blokkerer

## Hvordan identifisere
```sql
dp-soknad.public> SELECT count(1) FROM soknad_v1
LEFT JOIN soknad_tekst_v1 s ON soknad_v1.uuid = s.uuid
WHERE tilstand='Slettet' AND tekst is not null
[2022-12-13 14:52:08] 1 row retrieved starting from 1 in 113 ms (execution: 36 ms, fetching: 77 ms)
```

## Hvordan løse
TODO: Legg til beskrivelse
