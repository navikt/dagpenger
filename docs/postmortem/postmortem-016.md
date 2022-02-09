---
layout: page
title: 20.05.2021 - Dagpenger innsendinger rutes til feil behandlende benk
parent: Postmortems
nav_order: 3
has_children: false
---

# Innløpet: Dagpenger innsendinger (Nye søknader, Gjenopptak, Ettersendelser) rutes til feil behandlende enhet/benk

**Dato:** 20.05.2021

**Av:** Geir A. Lund

**Status:** Løst

**Sammendrag:** 

Innløpet for dagpenger (dp-mottak) gikk over til å bruke AzureAd sikkerhetsmekanisme mot PDL-apiet (personinformasjons-apiet) i GCP
den 19.05.2021 ca kl 13:05. Det var en feil i PDL-apiet som gjorde at vi ikke fikk informasjon om geografisk tilknytning som vi bruker til å bestemme hvilken behandlende enhet(benk i Arena) som skal saksbehandle innsendingen.
Videre tolket vi feilen da at brukeren hadde ikke hadde norsktilknyting. 

**Konsekvens:** 

Innsendinger ble sendt til feil behandlende enhet

**Rotårsaker:** 

- En feil i PDL-apiet som gjorde at vi ikke hadde tilgang til geografisk tilknytning for en bruker.
- Innløpet tolket svaret til PDL-apiet feil (tolket ikke feilmeldinger i svaret)


**Utløsende faktor:** 

Overgang til AzureAd sikkerhetsmekanisme mot PDL-apiet

**Løsning:** 

Skrudde av innløpet til vi hadde kontroll og gjorde nødvendige feilrettinger

Feilrettinger: 

- [Fiks av PDL-apiet](https://github.com/navikt/pdl/commit/a7441e2ec89abddeced78fb1f26d9af39c4d99bc#diff-59bd874662669f40d76d24296852bfac918eb9664c0f44f41229f62d1d52d06fL39-L55) (Takk #mfn teamet)
- [Fikse tolkning av svaret fra PDL i innløpet](https://github.com/navikt/dp-mottak/commit/d77fe427b9e946f514d44d96e0806776cb163f7c)

**Påvisning:** 

Sak til dagpenger-vaktkanalen (#team-dagpenger-vakt) via porten.


## Hva lærte vi?

### Hva gikk bra

- Fant feilen fort etter at innmelder gjorde hos oppmerksom på den.

### Hva gikk dårlig

- Ble ikke oppdaget via alarmer eller overvåkning
