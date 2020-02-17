# Innløp stoppet opp og gikk i automatisk restart 

**Dato:** 14.02.2020

**Av:** Geir André Lund

**Status:** Pågående

**Sammendrag:** 

Feil ved skriving til Kafka endte opp i at  4 (?) meldinger ble lest på nytt. Disse meldingene var allerede behandlet og feilet grunnet oppdatering mot joark på ny.  

**Konsekvens:**

Innløpet stoppet opp og kunne ikke behandle innkomne søknader

**Rotårsaker:** Feil ved skriving til Kafka ()

**Utløsende faktor:** 

Feil ved skriving til Kafka som endte med at tilstanden på søknadsbehandlingen ikke ble skrevet tilbake til Kafka.  

**Løsning:** Hoppet over journalposter/søknader som feilet. Disse var allerede behandlet. 

**Påvisning:** Automatisk alarm i #team-dagpenger-alert 

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ---- | ---- | ---- | --- |
| Hindre at feilende skriving mot Kafka hindrer behandling av søknader | forbedring | team dagpenger  |   |


## Hva lærte vi?

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

Det var "bare" 4 søknader som feilet. 

## Tidslinje

14.02.2020
- 18:52 - Alarm om at dagpenger-journalforing-ferdigstill er nede (https://nav-it.slack.com/archives/CAHJ7634G/p1581702773024000)
- 19:22 - Alarm oppdaget
- 19:22 - 20:00 ish - Feilsøking. Filtrerte ut 1 søknadsbeahndling som feilet. Feilet fortsatte
- 20:00ish - Fant ut at det var 4 feilende behandlinger av søknader, filtrerte ut samtlige
- 20:42 - Alarm er løst 

## Linker