---
layout: page
title: Vakt, logger og diverse
parent: Dagpenger utviklerdokumentasjon
nav_order: 3
has_children: false
---

# Dashboards

[Status]

[Kalkulator og innsyn](https://grafana.adeo.no/d/JxNaGSxZk/digitale-dagpenger-drift-sbs-apper?orgId=1)

[Innløget og regler](https://grafana.adeo.no/d/cpFY0XiWz/digitale-dagpenger-drift-dashboard?orgId=1&refresh=30s)

[Feil i logger](https://logs.adeo.no/goto/95ed7ef38f2930d6a09aa692872eca57)


# Dagpengervakt - @dagpenger-vakt

* Har vakt, en arbeidsuke om gangen, fra 08:00 - 16:00 (saksbehandlingstiden)
* Skal følge med på #team-dagpenger-alert Slack kanalen
* Skal følge med forespørsler fra andre kanaler (jira, slack meldinger @dagpenger-vakt et )
* Har beslutningsmyndighet til å prioritere over saker som er i gang ("stop-the-line")
* Skal sørge for å mønstre på neste vakt hver fredag
* Loggføre incidents/forespørsler
* Endre @dagpenger-vakt alias i Slack.
* Være tilgjenglig på slack og telefon.
* Være 30 min unna laptop.

# Tilganger

MÅ:
* kubectl tilgang til produksjonsklustrene.
* [Tilgang til logger](https://logs.adeo.no) 
* [Tilgang til grafana](https://grafana.adeo.no) 

BØR:
* Fungerende utvikerimage.

# HOWTO

## Finne historikk over henvendelser (søknad sendt inn etc)

Per 09.06.2022 kan en sjekke om en bruker har forsøkt sendt inn søknad gjennom å koble seg på henvendelses-databasen. Denne databasen må en eksplisitt spør om tilgangt til via identhåndtering.
Databasenavn: `jdbc:oracle:thin:@//a01dbfl043.adeo.no:1521/henvendelse`

Hvis du har tilgang til fødselsnummer eller aktørid kan en kjøre denne spørringen:

```sql

-- hvis du må finne aktørid 
SELECT aktorid, fnr from HENVENDELSE.AKTOR_FNR_MAPPING where FNR = '<fnr>';

SELECT BEHANDLINGSID, 
       TYPE, 
       STATUS, 
       TEMA, 
       OPPRETTETDATO, 
       INNSENDTDATO, 
       SISTENDRETDATO, 
       JOURNALFORTTEMA, 
       JOURNALPOSTID 
FROM HENVENDELSE.HENVENDELSE WHERE AKTOR ='<aktoer_id>' AND TEMA = 'DAG' ORDER BY INNSENDTDATO ASC ;
      
```

