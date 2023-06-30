---
layout: page
title: 26.03.2023 - Feil i registrering av timer ført på meldekort
parent: Postmortems
nav_order: 3
has_children: false
---

# Feil i registrering av timer ført på meldekort

**Dato:** 15.06.2023

**Av:** Knut Magne Riise

**Status:** Løst

**Sammendrag:** 
En kombinasjon av at frontend brukte tidsobjekter og at brukere satt i forskjellige tidssoner gjorde at timer ble forskjøvet til dagen før på meldekortet, som var meget uheldig hvis denne dagen timene ble forskjøvet til ikke eksisterte innenfor meldeperioden og dermed forsvant fra rapporteringen.

**Konsekvens:** 
Et mindre antall brukere som har rapportert timer fra en tidligere tidssone som har rapportert timer på den første dagen i meldekortperioden forsvant fra rapporteringen som igjen har ført til at brukere har fått en litt høyere utbetaling enn de burde.

**Rotårsaker:** 
At frontend/bruker bestemmer over hvordan tidsobjektene/datoene rapporteres på og føres inn i et meldekort mens backend er den som faktisk registrerer datoene på meldeperioden.
Frontend får en periode fra backend, konverterer det til GMT kl 00:00, bruker rapporterer i GMT-x tidssone uten klokkeslett, frontend konverterer til GMT som da altså blir dagen før og backend ser det som en dag utenfor den faktiske meldeperioden og lagrer ikke timene.

**Utløsende faktor:**
Feilen ble synliggjort i overgang til sommertid, som gjorde at brukere i norge som sendte inn rundt midnatt havnet i feil tidssone og rapportere for en dag tidligere, hvis denne dagen da var den første i meldeperioden så forsvant timene.

**Løsning:**
Backend definerer periodene og genererer opp dagene/datoene for frontend. Frontend får kun en liste med de 14 rapporteringsdagene og skal ikke lage egne datoer. Bruker fyller altså inn for dag 1-14 og ikke dato DD-MM-YYYYP14D

**Påvisning:**
En observant bruker meldte inn at en rapportert dag var forskjøvet i meldekortet hvor overgangen til sommertid skjedde.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --------- |

## Hva lærte vi?
Ikke la frontend overstyre noe som backend egentlig styrer
Dato/tid er vanskelig

### Hva gikk bra
Vaktordningen som så på, identifiserte, fikset, evaluerte, fikset litt mer
At det i 99% av tilfellene kun var til gunst for bruker
At vi kunne skrive om logikken til å slippe at slike problemstillinger ville oppstå uten å måtte brekke avhengigheter/ha nedetid

### Hva gikk dårlig
At feilen levde helt frem til sommertid før vi oppdaget den
At vi ikke kan garantere hvorfor feilen oppstod

### Hvor hadde vi flaks
At en bruker meldte inn at vi gjorde feil

## Tidslinje
- 04.08.2022 
Mulig introduksjon av feil
https://github.com/navikt/meldekort/commit/6f30ef7257d942a55cc85287ce63772bd86ec967

- 25.04.2023 
Meldt inn i jirasak FAGSYSTEM-275004 at bruker det som lagres ikke samsvarer med det som ble rapportert i løsningen 

- 26.04.2023 
Feilsøking begynner 

- 02.05.2023 
Første fiks kommer ut
https://github.com/navikt/meldekort/commit/bb8dfb589ae4d1d2f77fa32a19a474ac4ac72c49
https://github.com/navikt/meldekort/commit/bb122aecef61097e5172e5a4816abd732fd9cb06

- 03.05.2023 
Analyse av omfang utvides til å se om det gjelder andre tilfeller enn bare sommertidskiftet 

- 08.05.2023 
Indikasjoner fra logger på at fiks introduserte et annet problem med å sende inn meldekort, da vi var litt ekstra på vakt for å evaluere fiksen 

- 10.05.2023 
Omskriving av logikk for å forhindre hele problemstillingen
https://github.com/navikt/meldekort/commit/0cb10b97153459949f3e0deb1ffd37ffbe2e8f2b
https://github.com/navikt/meldekort-api/pull/249

## Linker
meldekort frontend (public) https://github.com/navikt/meldekort/
meldekort backend (private) https://github.com/navikt/meldekort-api