---
layout: page
title: Kjente feil
parent: Rutiner ved vakt
nav_order: 3
has_children: false
---

# Manuelle tiltak ved kjente feilsituasjoner
## Slettejobben stopper pga et event som blokkerer

### Hvordan identifisere søknaden det gjelder
```sql
dp-soknad.public> SELECT count(1) FROM soknad_v1
LEFT JOIN soknad_tekst_v1 s ON soknad_v1.uuid = s.uuid
WHERE tilstand='Slettet' AND tekst is not null
```
### Hvordan løse
Manuelt slette søknaden fra databasen
TODO: Legg til fremgangsmåte

## Mottok aldri løsning for `<et eller annet behov>`

### Behov <behovId> mottok aldri løsning for "Barn" innen X minutter og Y sekunder
Denne kan trygt ignoreres. TODO legge til begrunnelse.

