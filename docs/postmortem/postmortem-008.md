# Innløp stoppet opp og gikk i automatisk restart 

**Dato:** 14.02.2020

**Av:** Geir André Lund

**Status:** Pågående

**Sammendrag:** Feil ved skriving til Kafka endte opp i at  4 (?) meldinger ble lest på nytt. Disse meldingene var allerede behandlet og feilet mot oppdatering av joark.  

**Konsekvens:** Innløpet stoppet opp og kunne ikke behandle innkomne søknader

**Rotårsaker:** Feil ved skriving til Kafka ()

**Utløsende faktor:** Feil ved skriving til Kafka som endte med at tilstanden ikke ble skrevet

**Løsning:** Hoppet over journalposter/søknader som feilet. 

**Påvisning:** Automatisk alarm i #team-dagpenger-alert 

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |

## Hva lærte vi?

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

## Tidslinje

## Linker