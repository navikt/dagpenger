# Søkere som velger engelsk språk på dagpenger-søknadsdialogen får ikke levert dagpengesøknad

**Dato:** 04.02.2020

**Av:** Knut Magne Riise

**Status:** Antatt løst - under overvåkning

**Sammendrag:** Spesifikk tekstformattering i informasjonstekster rundt innsending av vedlegg i de engelske tekstene
gjorde at applikasjonen som transformerer søknad til pdf ga feilmelding og forhindret søknad i å bli sendt

**Konsekvens:** Rundt 23 personer opplevde feilmelding og fikk ikke mulighet til å levere dagpengesøknad digitalt i tidsrommet 24.1.2020-04.02.2020
hvis de hadde dokumentasjonskrav på noen typer vedlegg.

**Rotårsaker:** Applikasjonen som transformerer søknad til pdf tar med tekster beregnet for visning av hjelpetekst i dialogen for opplasting av vedlegg

**Utløsende faktor:** Oppdatering av tekster for å gjøre språket lettere å forstå i søknadsdialogen og vedleggsdialogen, både på norsk og engelsk.

**Løsning:** Formattere engelske teksten slik at applikasjonen som oppretter pdf ikke blir sur og kaster feil.
Rapporterte inn liste med antatt påvirkede personer og første dato de kom i kontakt med feilen.

**Påvisning:** Nøye gjennomgang av logger etter innmelding fra nav kontaktsenter 03.02.2020 om at en bruker ikke fikk sendt søknad

## Aksjonspunkter

| Aksjon                                                                                                     | Type       | Eier           | Referanse                                      |
| ---------------------------------------------------------------------------------------------------------- | ---------- | -------------- | ---------------------------------------------- |
| :---                                                                                                       | :---       | :---           | :---                                           |
| Alerts må være reelle, endre errors til kun å være hendelser som forhindrer bruker i å fylle/levere søknad | Forbedring | Team dagpenger | https://github.com/navikt/dagpenger/issues/304 |

## Hva lærte vi?

Tekststrenger er tett koblet med logikk i applikasjonen for dagpengesøknader

### Hva gikk bra

Vi fant feilen etter god søking i logger, rettet feil og deployet raskt etter den ble funnet.

### Hva gikk dårlig

Overvåkningen vår på denne applikasjonen hadde mange feilaktige produksjonsadvarsler,
slik at de faktiske feilene ble oversett (ulv ulv)

### Hvor hadde vi flaks

Det ble rapportert inn at at bruker hadde problemer med søknaden

## Tidslinje

24.01.2020 | Nye tekster blir publisert samtidig som at man migrerer over til github/naiserator
03.02.2020 | Feil blir meldt inn i jira
03.02.2020 | Feilsøking starter
04.02.2020 | Feil funnet, rettet kort tid etterpå

## Linker

https://github.com/navikt/dagpenger/issues/304
https://github.com/navikt/dp-soknad-innsending
https://github.com/navikt/dp-soknad-server
https://github.com/navikt/dp-soknad-frontend
