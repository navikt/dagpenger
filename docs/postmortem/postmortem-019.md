---
layout: page
title: 26.04.2023 - Søknad og ettersending for dagpenger var midlertidig utilgjengelig
parent: Postmortems
nav_order: 3
has_children: false
---

# Søknad og ettersending for dagpenger var midlertidig utilgjengelig

**Dato:** 26.04.2023

**Av:** Knut M Riise

**Status:** Løst

**Sammendrag:** 
Grunnet modifikasjoner av ingress konfigurasjon under lansering av ny produktside for dagpenger, 
var vi litt for aggressive og tok over url'er som skulle gått til side for 
søknadsdialog og ettersending/opplastning av vedlegg til dagpenger

**Konsekvens:** 
Søknadsdialogen og ettersending av dokumentasjon for dagpenger var utilgjengelig i perioden fra 12:30 til 14:00 26. april 2023.

**Rotårsaker:**
Aggresiv bruk av regex for konfigurasjon av ingress på nais platformen.

**Utløsende faktor:**
Under lansering av ny produktside (og ny ingress) kom det frem at nks sine kort-url'er som har dagpenger til prefix ikke lengre fungerte.
Dette kom av at enonic holder redirectene fra kort-url til egentlige sider, 
men siden nais plattformen tildeler ingresser slik at applikasjonen som er mest spesifikk "får" ingressen overstyrte
altså vår app nav.no/dagpenger-kort-url da vi hadde tatt nav.no/dagpenger og dermed får prioritet over enonic som har nav.no.
Vi prøvde å løse dette ved å sette ingressen som en regex (https://github.com/navikt/dp-produktside-frontend/commit/02e80d46409bddfc603fe991faafb3706502f135)
men dette gjorde at vi "overstyrer" nais sin politikk ved å si at vi tar *ALLE* ingresser som har en variasjon av nav.no/dagpenger, 
inkludert nav.no/dagpenger/dialog/soknad. Søknaden for dagpenger ble dermed utilgjengelig.

**Løsning:** 
Spesifisere tre ingresser i konfigurasjon fremfor å stjele **alt** etter nav.no/dagpenger

**Påvisning:**
Feilen ble påvist gjennom god live manuell testing for lanseringen av dagpengerproduktsiden.
Man trodde man fant en brukket lenke for å gå til søknaden, men det var altså ingress konfigurasjonen som sendte oss tilbake til produktsiden sin 404.

## Hva lærte vi?
At vi ikke har alarmer for at en annen app stjeler ingressen. Vi hadde en failsafe som sjekker adressen til søknaden, m
en den tenkte at alt var greit siden den fikk en respons (fra nye produktsiden vår). 

### Hva gikk bra
Vi oppdaget feilen og fikset problemet i løpet av fem minutter.
### Hva gikk dårlig
Vi brukte over en time på å finne feilen. Alarmen for søknadsdialog trigget ikke da den fikk respons fra en annen app
### Hvor hadde vi flaks
At vi var grundig i den manuelle sjekkingen vår når vi lanserte den nye siden.
## Tidslinje
- 26.04.2023
- ~10:00 Deploy av ny produktside (https://github.com/navikt/dp-produktside-frontend/commit/ab4264a56f07c8724193ac939edfef797b3c4171) og (https://github.com/navikt/dp-produktside-frontend/commit/f376a30eff9b11eebfe17b543b354d02d8f93f47)
- ~12:40 Deploy av ingress som ikke tar kort-url fra enonic, men som konfiskerer alt bak nav.no/dagpenger/* (https://github.com/navikt/dp-produktside-frontend/commit/02e80d46409bddfc603fe991faafb3706502f135)
- ~13:30 Vi oppdager at man ikke kan nå dagpengesøknaden, og alle forsøk på å nå den sendes til produktsiden.
- ~13:40 Fjerner regex i ingresskonfigurasjon (https://github.com/navikt/dp-produktside-frontend/commit/04c8a95009488d04108905b38082606129fa86b1)
- ~13:55 Lager egne manuelle ingresser for å nå de to sidene våre (produktside og historikk for produktside) (https://github.com/navikt/dp-produktside-frontend/commit/8e5550bcbbf1e0461c6ae4a80876fe291b56b6c4)
- ~14:20 Lagt til ingress for api endepunktet slik at historikk faktisk kan hente historiske data (https://github.com/navikt/dp-produktside-frontend/commit/1bae70b51c187954f3b29be2648dce8a8ce8e106)
## Linker
 - Nye produktsiden for dagpenger: https://github.com/navikt/dp-produktside-frontend
 - Søknadsdialogen for dagpenger: https://github.com/navikt/dp-soknadsdialog