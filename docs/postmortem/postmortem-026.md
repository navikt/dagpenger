---
layout: page
title: 22.02.2024 - Feil ved validering av bundlede PDF'er
parent: Postmortems
nav_order: 3
has_children: false
---

# Feil ved validering av bundlede PDF'er

**Dato:** 22.02.2024 kl. 10:00 - 14:00

**Av**  Giao The Cung og Celine Ten Dam

**Status:** Løst

**Sammendrag:** Enkelte brukere kunne ikke sende inn dagpenger søknaden sin. 

**Konsekvens:** I tidsperioden feilen oppsto kunne ikke enkelte brukere sende inn dagpenger søknaden sin.

**Rotårsaker:** Oppgrading av et tredjepartsbibliotek endret struktur på PDF'er som blir bundlet. Dette førte til at validering den bundlede PDF'en feilet.
Feilen ble også maskert fordi selve kodenendringen er i et versjons katalog i et repository, katalogen blir igjen brukt av et felles bibliotek som igjen blir bruke av selve applikasjonen 
der feilen oppstod. I tillegg har det vært problemer med bygg og deploy av applikasjonen, slik at det var en større commit med flere endringer som ble deployet.
Dette gjorde det vanskelig å finne rotårsaken til feilen.

**Løsning:**  Rulle tilbake til en versjon av tredjepartsbiblioteket som ikke endret strukturen på PDF'ene. 
Ta det aktuelle PDF biblioteket ut av versjons katalogen og plassere det der det brukes.
Få tak i noen av PDF'ene som feilet som en utgangspunkt for å skrive bedre tester slik at oppgraderingen kan gjennomføres, 
samt tryggere ved fremtidige oppgraderinger.

**Påvisning:** Alarm om at antall feil i loggene økte.

## Hva lærte vi?

Vi mangler tester som kan avdekke slike feil.
Vi manger alarmer som kan avdekke et plutselig økning i antall feil av denne typen

### Hva gikk bra
Feilen ble relativt fort oppdaget og rettet. 

### Hva gikk dårlig
Feilen ble oppdaget i produksjon.

### Hvor hadde vi flaks

## Tidslinje

Feil introdusert: 22.02.2024 10.00
Feil oppdaget: 22.02.2024 13.00
Feil rettet: 22.02.2024 14.00


