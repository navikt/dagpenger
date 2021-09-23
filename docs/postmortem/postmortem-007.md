---
layout: page
title: Søknad om dagpenger har ikke generert noen oppgave til fordeling
parent: Postmortems
nav_order: 3
has_children: false
---


# Søknad om dagpenger har ikke generert noen oppgave til fordeling 

**Dato:** 27.01.2019

**Av:** Geir André Lund

**Status:** Pågående

**Sammendrag:** Søknad om dagpenger har ikke generert noen oppgave til fordeling 

**Konsekvens:** Blir ikke opprettet oppgaver for oppfølgning i Arena eller Gosys. Journalpost ble ikke ferdigstilt. 

**Rotårsaker:** 
Kontekst: Vi skulle overta ruting av ny søknad fra batchbaserte BRUT til vårt strømbaserte innløp.

For å unngå race condition tenkte vi at vi kunne skru av innløpet vårt før vi skrudde av BRUT. Tanken var da at innløpet ville fortsette fra punktet vi skrudde av på, mens BRUT skulle behandle alle søknader frem til det ble skrudd av. Etter dette skulle vi kunne skru på innløpet som ville hoppe over alle journalposter behandlet av BRUT. Problemet var at BRUT ikke behandlet noen av søknadene vi hadde trodd den skulle. Her var det en logisk feilslutning. Siden BRUT kjører med sjelden batcher, ble 182 søknader antatt å bli behandlet av BRUT, men BRUT rakk aldri å kjøre batchen sin før den ble skrudd av.


**Utløsende faktor:**  Vi skrudde av innløpet når vi burde hatt det på.

**Løsning:**  Spilte av joark-eventer på nytt fra 27. januar 2020 

**Påvisning:** Jira sak fra NAV kontor (https://jira.adeo.no/browse/FAGSYSTEM-95555)


## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |

## Hva lærte vi?´

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

Vi kunne spille av hendelsene på nytt.

## Tidslinje
## Tidslinje
Veldig ca. tidslinje
|Klokkeslett | Hendelse |
|:--- |:---- |
| 27.01.20 - 07:00 | BRUTs siste batch på dagpenger går | 
| 27.01.20 - 11:00 | Vi skrur av innløpet som har markert 182 søknader som "behandles av BRUT" |
| 27.01.20 - 13:00 | BRUT blir faktisk skrudd av  |
| 27.01.20 - 14:00 | Innløpet skrus av |
| 12.02.20 - 14:00 | Fagsak opprettes, feilsøking starter |
| 13.01.20 - 10:00 | En fikseapplikasjon lanseres |
| 14.01.20 - 10:00 | Fikseapplikasjonen er ferdig, men har ikke fikset grunnet type-trøbbel (journalpostid var long, ikke string  |
| 14.01.20 - 18:00 | Fikseapplikasjonen er ferdig og har journalført det den skulle |

## Linker
