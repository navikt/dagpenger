# Beregninger for vedtak som er brukt er fjernet 

**Dato:** 20.02.2020

**Av:** Geir André Lund

**Status:** Løst

**Sammendrag:** Behov og subsumsjoner for vedtak er fjernet fordi de ikke var merket som brukt

**Konsekvens:** Re-beregning av subsumsjoner feilet fra Arena. 

**Rotårsaker:** 

- Det mangler 745 vedtak i dp-regel-api
- Disse vedtaken er fra perioden 01.07.2019 til 17.07.2019

Årsakssammenheng: 

Vedtakene kommer via GoldenGate topicet privat-arena-dagpengevedtak-ferdigstilt. Dette topicet er ble opprettet med levetid på 1 dag. I og med at vi ikke hadde vedtakslytteren klar før 19. juli har vi dermed ikke fått markert beregningsid (inneforstått vedtakid) som brukt i dp-regel-api databasen. Vaktmesteren har dermed trodd at disse beregningsid ikke ble brukt og slettet det.

**Utløsende faktor:** Kafka-topic for privat-arena-dagpengevedtak-ferdigstilt hadde levetid på kun 1 dag. 

**Løsning:** Har ikke løsning på beregnigner som allerede er fjernet. 

**Påvisning:** Arena-leverandør gjorde oss klar over det. 

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
| Avstemming mot liste fra Arena | oppgave | team dagpenger | n/a |
| Øker bevaringstida til 'privat-arena-dagpengevedtak-ferdigstilt' | fikse | team dagpenger | https://github.com/navikt/dagpenger-iac/commit/8571fd43e2263c63e5a8790ee3af04c57d82f75c |

## Hva lærte vi?

Vi må huske på lagringstid for Kafka topic per bruksscenario

### Hva gikk bra

Vi mangler bare vedtakene fra perioden 01.07.2019 til 17.07.2019

### Hva gikk dårlig

Vi mangler vedtakene fra perioden 01.07.2019 til 17.07.2019 :(
