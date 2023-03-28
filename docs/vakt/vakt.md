---
layout: page
title: Vakt, logger og diverse
parent: Rutiner ved vakt
nav_order: 3
has_children: false
---

# Dashboards

[Status]

[Søknadsdialogen](https://grafana.nais.io/d/hOx7i8I4z/ny-soknadsdialog?orgId=1&refresh=30s)

~~[Kalkulator og innsyn](https://grafana.nais.io/d/JxNaGSxZk/digitale-dagpenger-drift-sbs-apper?orgId=1)~~ TODO: hvor finnes denne nå?

[Innløpet og regler](https://grafana.nais.io/d/cpFY0XiWz/overvakning-og-alarmer-fra-tjeneste-vare-drift-dashboard?orgId=1&refresh=30s)

[Feil i logger](https://logs.adeo.no/goto/95ed7ef38f2930d6a09aa692872eca57)


# Dagpengervakt - @dagpenger-vakt

* Har vakt, en arbeidsuke om gangen, fra 08:00 - 16:00 (saksbehandlingstiden)
* Skal følge med på #team-dagpenger-alert Slack kanalen
* Skal følge med forespørsler fra andre kanaler (jira, slack meldinger @dagpenger-vakt etc )
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

# Oppfølging av saker som kommer inn i #team-dagpenger-vakt
Forventet SLA på å løse disse sakene er innen X timer.

1. Les igjennom saken, og trekk inn andre som eventuelt trengs for å løse saken.
   1. Marker innlegget med 👀 når du har begynt å se på saken 
1. I det vi har funnet et svar eller løsning, så skal dette kommeteres på den tilhørende FAGSAK-jira-oppgaven.
1. Skriv inn en kommentar, og trykk på knappen "Del internt".
   1. Sett en ✅ på innslaget i slack-kanalen.

# HOWTO

## Scenario: "Kan du sjekke om bruker har forsøkt å sende inn søknad"

Dette får man ofte når det kommer klage og ankesaker.

Hvis det er mer enn 3 mnd siden bruker sier hen har sendt inn søknad, så har vi `ingen spor` på det. Grunnen:
- Logger lagres ikke mer enn 3 mnd tilbake i tid
- Av personvernhensyn så sletter vi søknader som er påbegynt og ikke endret av bruker på 7 dager.
- Det lagres kun data om innsendte søknader

Hvis det er under 3 mnd siden bruker sier hen har sendt inn søknad:
- Sjekk logger: [dp-soknad i prod siste 3 mnd](https://logs.adeo.no/goto/482756b0-3402-11ed-8607-d590fd125f80)
- Sjekk sikkerlogg: [tjenestekall for dp-soknad i prod siste 3 mnd](https://logs.adeo.no/goto/c1e0af60-3402-11ed-8607-d590fd125f80)
- Se om det skjedde mye feil eller andre underlige ting i perioden bruker sier hen sendte inn søknad

## Finne historikk over henvendelser (søknad sendt inn etc)

### Ny søknadsdialog

1. Bruk nais cli verktøyet for å logge på databasen
   Se instruksjoner for å innstallere [nais cli verktøyet](https://docs.nais.io/cli/commands/postgres/)
2. Sørg for å være i riktig NAIS cluster (`prod-gpc`)
3. Bruk proxy funksjonalitet: 
   `nais postgres proxy dp-soknad`
   Kopier connection url inn i et DB verktøy (IntelliJ har en super en)
   Connection url ser nå sånn ut: 
  ```
   Starting proxy on localhost:5432
   Connection URL: jdbc:postgresql://localhost:5432/dp-soknad?user=<din.nav.epost>@nav.no
   ```
4. Bruk `pgpass` autentisering og logg på 
5. Finn historikk for en person ved å kjøre: 
   ```
   select opprettet, tilstand, sist_endret_av_bruker, endret, innsendt from soknad_v1 where person_ident = '<iden>'
   ```


### Gammel søknadsdialog
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

