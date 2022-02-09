---
layout: page
title: 13.03.2020 -  Innløpet stoppet da Arena var nede for vedlikehold
parent: Postmortems
nav_order: 3
has_children: false
---

# Innløpet stoppet da Arena var nede for vedlikehold

**Dato:** [13.03.2020]

**Av:** @geiralund

**Status:** [Løst]

**Sammendrag:** 

Vi har lagt på en “guard” mot at meldinger ikke leses mer enn 10 ganger og når 1 hendelse feilet 9 ganger på oppgaveopprettelse mot Arena blokkerte det effektivt innløpet. 

**Konsekvens:** 

Innløpet stoppet opp.  Dagpengehenvendelser (søknad, klage, gjennopptaksøknader etc) ble stående i behandlingskø

**Rotårsaker:** 

"Sikringen" virket mot sin hensikt. Arena var nede p.g.a. vedlikehold slik at en ikke kunne opprette oppgaver via webtjenesten. Dette resulterte i at dagpenger-journalforing-ferdigstill ble restartet og håndterte meldingen på nytt. 
I hendelsen (Packet) blir en leseteller oppdatert hver gang en hendelse blir håndtert og det er en "sikring" i dagpenger-journalforing-ferdigstill som ikke håndterer hendelse som er håndter mer enn 10 ganger. "Sikringen" kaster en feil og alle hendelser etter det blir ikke håndtert.  



**Utløsende faktor:** [Hva gjorde at feilen oppstod?]

**Løsning:** 

Filtrerte ut journalpostid som stanget slik at den ble behandlet videre. 


**Påvisning:** 

Oppdaget det tilfeldigvis gjennom å se på grafana-boardet vårt (https://grafana.adeo.no/d/cpFY0XiWz/digitale-dagpenger-drift-dashboard?orgId=1).   

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
|  Håndtere at Arena er nede i innløpet |  oppgave |  teamdagpenger | https://github.com/navikt/dagpenger-journalforing-ferdigstill/issues/27 | 
|  Undersøke hvorfor ikke en alarm gikk i #team-dagpenger-alerts | oppgave | teamdagpenger  | | 
## Hva lærte vi?


### Hva gikk bra

Lett å fikse (https://github.com/navikt/dagpenger-journalforing-ferdigstill/commit/d318de13b417f7589f65e622f24e89a1362db736)

### Hva gikk dårlig

Varsling - det gikk ikke en automatisk 

### Hvor hadde vi flaks

Det var bare 1 hendelse som gikk i stå.


## Tidslinje

- 23:06ish - Arena tas ned for vedlikehold
- 23:15 - Så loggfeil på dagpenger-journalforing-ferdigstill i driftdashboardet 
- 23:30 - La inn fiks på hendelse som gikk i stå (https://github.com/navikt/dagpenger-journalforing-ferdigstill/commit/d318de13b417f7589f65e622f24e89a1362db736)

## Linker