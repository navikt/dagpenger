# Tjenestekall for vurdering av minsteinntekt feilet

**Dato:** 23.08.2019

**Av:** Geir A. Lund

**Status:** Løst

**Sammendrag:** Inngangsvilkår minstearbeidsinntekt og beregning av periode kunne ikke beregnes i saksflyten i Arena

**Konsekvens:** Inngangsvilkår og beregning av periode for Dagpengesaker i Arena kunne ikke behandles i perioden

**Rotårsaker:** Problemer med Kafka-tilkobling utløste restart av applikasjonen dp-regel-periode, påfølgende restarter endte i en `CrashLoopBackoff`.  `CrashloopBackoff` kom av at start av ny instans av dp-regel-periode ikke klarte å få tak i `ca-bundle.pem` (SSL sertifikater)

```
Error: failed to start container "dp-regel-periode": Error response from daemon: OCI runtime create failed: container_linux.go:348: 
starting container process caused "process_linux.go:402: container init caused \ca-bundle.pem\" caused \\\"no such file or directory\\\"\"": unknown

```

**Utløsende faktor:**  Problemer med Kafka-tilkobling utløste restart av applikasjonen dp-regel-periode - havnet i  `CrashLoopBackoff` (utilgjengelig) p.g.a. manglende sertifikat-fil (`ca-bundle.pem`)

**Løsning:** Slettet instanser i `CrashloopBackoff` og startet nye instanser av dp-regel-periode.

**Påvisning:** Automatisk varsling av feil i loggene til Slack og beskjed fra brukerstøtte.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
| Legge til alarm for `CrashLoopBackoff` | forhindre | @geiralund | (Done)   |
| Lage alarm på SLA mot Arena  | forhindre | @geiralund | https://github.com/navikt/dagpenger/issues/213  |


## Hva lærte vi?

### Hva gikk bra

- Automatisk restart av appene etter Kafka-tilkoblingsfeil

### Hva gikk dårlig

- Ingen alarmer gikk av at dp-regel-periode stod i `CrashLoopBackoff` (var utilgjengelige) fra 00:21 den 23.08.2019
- Alarm på SLA mot Arena (Gikk over 20 sekunder før Arena fikk feilsvar)

### Hvor hadde vi flaks

- Enkel fiks (restart via kubectl)

## Tidslinje

23.08.2019

- 00:07: Første alarm på Slack - tilkoblingsfeil mot Kafka
- 00:08: Friskmeldelse på Slack
- 00:23: Alarm på Slack - tilkoblingsfeil mot Kafka
- 00:28: Friskmeldelse på Slack
- 06:55: Alarm på Slack - svar til Arena feiler
- 08:08: Henvendelse fra brukerstøtte om at "Tjenestekall for vurdering av minsteinntekt feilet."
- 08:15: Slettet instanser i `CrashloopBackoff` og startet nye instanser av dp-regel-periode
- 08:16: dp-regel-periode instansene kjører  
- 08:25: Brukestøtte bekrefter at feilen er løst

## Linker