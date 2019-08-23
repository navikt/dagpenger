# Kafka consumere for privat-dagpenger-subsumsjon-brukt og privat-dagpenger-subsumsjon-brukt-data har lag (meldinger i kø)

**Dato:** 23.08.2019

**Av:** Geir A. Lund

**Status:** Pågående

**Sammendrag:** Kafka consumere for privat-dagpenger-subsumsjon-brukt og privat-dagpenger-subsumsjon-brukt-data har LAG, dvs at melding ikke blir lest. 

**Konsekvens:** Subsumsjoner og inntekter blir ikke markert som "brukt". 

**Rotårsaker:** Problemer med Kafka-tilkobling utløste at Kafka-consumere stoppet. 

**Utløsende faktor:**  Problemer med Kafka-tilkobling 

**Løsning:**  Startet nye instanser av consumerene manuelt

**Påvisning:** Varsling på Dagpenger drift-dashboard om høy Kafka LAG

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
| Legge til alarm for Kafka lag | forhindre | @geirlund |  |
| Automatisk restart av Kafka-consumere | feilretting | @geirlund  |  |



## Hva lærte vi?

### Hva gikk bra

-  Varsling på Dagpenger drift-dashboard om høy Kafka LAG

### Hva gikk dårlig

- Ingen alarmer gikk av at consumerene hadde lag
- Automatisk restart av consumere virker ikke


### Hvor hadde vi flaks


## Tidslinje

23.08.2019


- 00:07: Problemer med Kafka-tilkoblingen, consumere stoppet antakeligvis i denne perioden
- 08:25: Lag påvist i Dagpenger drift-dashboard 
- ca 10:00: Restartet consumere (appene med consumerene)
- 10:05: Lag nede i 0 igjen 

## Linker