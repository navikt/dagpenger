---
layout: page
title: G-justering
parent: Dagpenger utviklerdokumentasjon
nav_order: 2
has_children: false
---

## G-justering

Grunnbeløpet (som vi ofte kaller G) justeres 1. mai hvert år og blir fastsatt etter trygdeoppgjøret.

Grunnbeløpet blir fastsett av Stortinget hvert år i takt med forventa lønns- og prisutvikling. Dette skjer vanligvis i
slutten av mai eller starten av juni måned og får tilbakevirkning fra mai.

For Dagpengers del er G-justering en reberegning av grunnlag (§4-11) og sats (§4-12) for vedtak som er innvilget fra 1.
mai til datoen den ny G'en er iverksatt. PT gjøres uttrekk av hvilke vedtak som skal justeres fra Arena.
I tillegg må den ny G'en legges til av beregning av krav til minste arbeidsinntekt (§4-4) og dagpengeperiode (§ 4-15)

Fremgangsmåte for hvordan g-justeringer er beskrevet
i [dp-grunnbelop](https://github.com/navikt/dp-grunnbelop#g-justering)

## Årlig G-justeringtest mot Arena

Arena vil kjøre en g-justeringstest mot LEL-2019 testmiljøet (dp-regel-*) der de krever en kopi av produksjonsdatabasen
for [dp-inntekt](https://github.com/navikt/dp-inntekt)

## 1. Bestill kopi av dp-inntekt produksjonsdatabasen

Arena vil i god tid før g-justeringstest forespør oss å ta kopi av dp-inntekt produksjonsdatabasen til testmiljøet.
dp-inntekt bruker `q0` databasen `dp-inntekt-db-q0` (host: `b27dbvl013.preprod.local`). Denne databasen blir kopiert fra
dp-inntekt sin produksjonsdatabase `dp-inntekt-db` (host: `a01dbfl039.adeo.no`)

1.1 Bestill bistand fra [team database](https://teamkatalog.nav.no/team/b6e266b0-9d76-480e-ae1f-585f04ace257) for å
gjøre selve kopien.

- Lag sak i porten - https://jira.adeo.no/plugins/servlet/desk/portal/542 - "Meld sak til IT"
    - Velg tjeneste: "Database"
    - Ansvarlig gruppe: "Team database"

  Beskriv:
    - Hvilken database og host det skal kopieres **til** (`dp-inntekt-db-q0` (host: `b27dbvl013.preprod.local`)
    - Hvilken database og host det skal kopieres **fra** (`dp-inntekt-db` (host: `a01dbfl039.adeo.no`)
    - Når kopies skal tas. Arena vil at det skal gjøres på likt tidspunkt som det gjøres kopi av Arenadatabasen
    - [Eksempel fra 2023](https://jira.adeo.no/browse/IKT-515839)

    ** NB! Dette må gjøres i god tid før selve g-justeringstestdag(ene) **

1.2 Gå mot `dp-inntekt-db-q0` for testmiljøet til dp-inntekt-api

- Endre database miljøkonfigurasjon for `dev` til å gå mot db `dp-inntekt-db-q0` og host `b27dbvl013.preprod.local`
- Commit og
  push ([eksempel fra 2023](https://github.com/navikt/dp-inntekt/commit/5f4f569670ade07b2d0d6beb4c2f0c9c122a84af)))
- Sjekk at dp-inntekt-api kjører OK

## 2. Legg til ny verdi for test Grunnbeløp

For Dagpenger ligger historiske G-verdier og Test-G-Verdier i [dp-grunnbelop](https://github.com/navikt/dp-grunnbelop)

I en test av g-justering bruker
vi [GjusteringsTest](https://github.com/navikt/dp-grunnbelop/blob/dd33088904de28eac3ddf6edeb5374b33c31ad50/src/main/kotlin/no/nav/dagpenger/grunnbelop/Grunnbelop.kt#L10)
verdien for å simulere.

Grunnbeløpverdien vil bestemmes av funksjonelle testere. (Fra 2023, sjekk kommentar
i https://jira.adeo.no/browse/ARENA-8157)

1. Oppdaterer `GjusteringsTest` med ny test
   G ([Eksempel fra 2023](https://github.com/navikt/dp-grunnbelop/commit/dd33088904de28eac3ddf6edeb5374b33c31ad50))
2. Commit og push til master
3. En ny versjon av dp-grunnbelop vil [releases](https://github.com/navikt/dp-grunnbelop/releases)

## 3. Oppdatere reglene med ny versjon av dp-grunnbelop

Oppdatere til ny versjon av dp-grunnbelop i:

1. [dp-regel-minsteinntekt](https://github.com/navikt/dp-regel-minsteinntekt)

    - Sett ny versjon av dp-grunnbelop
    - Sett virkningsdato for testgrunnbeløpet. Dette tidspunktet kalles "Fra dato Hengende G" og er spesifisert av
      testere
    - Oppdaterer tester
    - Commit og
      push ([eksempel fra 2023](https://github.com/navikt/dp-regel-minsteinntekt/commit/98d143dbb9eaaeda6902990b2b39d0fcbd3b0f91) )

2. [dp-regel-periode](https://github.com/navikt/dp-regel-periode)
    - Sett ny versjon av dp-grunnbelop
    - Sett virkningsdato for testgrunnbeløpet. Dette tidspunktet kalles "Fra dato Hengende G" og er spesifisert av
      testere
    - Oppdaterer tester
    - Commit og
      push ([eksempel fra 2023](https://github.com/navikt/dp-regel-periode/commit/19a1538243187830616a76262b650a8e3dd7c9a5) )

3. [dp-regel-grunnlag](https://github.com/navikt/dp-regel-grunnlag/)
    - Sett ny versjon av dp-grunnbelop
    - Sett virkningsdato for testgrunnbeløpet. Dette tidspunktet kalles "Fra dato ny G" og er spesifisert av testere
    - Oppdaterer tester
    - Commit og
      push ([eksempel fra 2023](https://github.com/navikt/dp-regel-grunnlag/commit/2c68224a3ae58e6694c34becedd27b17e8d4a966) )


4. [dp-regel-sats](https://github.com/navikt/dp-regel-sats/)
    - Sett ny versjon av dp-grunnbelop
    - Sett virkningsdato for testgrunnbeløpet. Dette tidspunktet kalles "Fra dato ny G" og er spesifisert av testere
    - Oppdaterer tester
    - Commit og
      push ([eksempel fra 2023](https://github.com/navikt/dp-regel-sats/commit/66cb81c11916e3fa492a5a8304adbef5450b9a9a) )

## 4. Skru på g-justering i testmiljøet

Selve `GjusteringsTest` toggles på via unleash toggelen: `dp-g-justeringstest`
(https://unleash.nais.io/#/features/strategies/dp-g-justeringstest)

Denne toggles PÅ når testerene og Arena er klar for det.

## 5. Når g-justering test er ferdig

1. Toggle AV toggelen: `dp-g-justeringstest` i unleash
2. Gå tilbake til test databasen i dp-inntekt (reverter commit i steg 1)
3. Ferdig! 
