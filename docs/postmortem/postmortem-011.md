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


Alarm i #team-dagpenger-alert kanalen 

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |

## Hva lærte vi?

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

## Tidslinje

## Linker