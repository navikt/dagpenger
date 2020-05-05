# Brukere av kalkulator/forskuddsløsning har fått samme beregningsresultat

**Dato:** [05.05.2020]

**Av:** Geir A. Lund

**Status:** [Løst]

**Sammendrag:** 


Kombinert med en feil i hvordan vi slår opp inntekter og hacket vi har gjort i kalkulator/forskudd og innløpet (hvor vi har brukt samme vedtakId; -1337, -12345) fått samme inntekter. 
En spørring som skal hente inntekter basert på person + vedtaksid + beregningsdato så rett og slett bort fra person, så det ble kun vedtaksid + beregningsdato som ble brukt/unik. For vedtak i Arena så stemmer jo det, men kalkulator, forskudd og innløpet som bruker -1337 eller -12345 som vedtaksid ble det alltid den samme inntekten (for samme dato)


**Konsekvens:** 

- Forskudd ble beregnet på feil inntektsgrunnlag og gav feil svar for minstearbeidsinntekt, grunnlag og sats
- Dagpengekalkulatoren ble beregnet på feil inntektsgrunnlag og gav feil svar for minstearbeidsinntekt, grunnlag og sats

**Rotårsaker:** 

En spørring som skal hente inntekter basert på person + vedtaksid + beregningsdato så rett og slett bort fra person, så det ble kun vedtaksid + beregningsdato som ble brukt/unik.

**Utløsende faktor:**

Opprettelse av en ny tabell for å ta vare på inntekt basert på  person + vedtaksid + beregningsdato + fødselsnummer for å klargjøre automatisk saksbehandling av dagpenger. Denne endringen ble produksjonsatt 04.05.2020 kl 14:34:42 

**Løsning:** 

Fiks av SQL-spørring https://github.com/navikt/dp-inntekt-api/commit/8b92c8e1b35a4ef8abe025fa4b240ef8ae5a818e 

**Påvisning:** 

Forskuddteamet gjorde dagpengerteamet på at det var unormale antall minstearbeidsinntekt som ble avslått. Det synes også i våre [Grafanadashboards](https://grafana.adeo.no/dashboard/snapshot/fNMNpbOFEfBqVkUpgHT64Jq9zGtw4kOd)

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
| Fiks av SQL-spørring | Bugfix | Team dagpenger | [#401](https://github.com/navikt/dagpenger/issues/401)
| Manglende logger i Kibana fra dp-inntekt-api | Bugfix | Team dagpenger | [#403](https://github.com/navikt/dagpenger/issues/403)
| Legge inn sikkerlogg i gamle apps | Bugfix | Team dagpenger | [#404](https://github.com/navikt/dagpenger/issues/404)

## Hva lærte vi?

Enhetstester og integrasjontester burde funnet ut at dette var en feil under utvikling. Vi ser nå at mange av testene våre bruker fastsatte parametre og har dermed liten variasjon. Vi burde lære mer om property-testing for å kunne kjøre flere permutasjoner i koden. 

### Hva gikk bra

Fiksen var forholdsvis enkel å fikse


### Hva gikk dårlig

Vi lagret feil data for inntekt i beregning av Forskudd og Dagpengekalkulatorspørringer. 


### Hvor hadde vi flaks

Det var "bare" forkuddsløsning og Dagpengekalkulatoren som var skadelidende. Saksbehandling i Arena har ikke blitt påvirket av feilen, selvom saksbehandling av dagpenger i Arena ble stoppet ca 10:10 til ca. 12.  

## Tidslinje


### 04.05.2020
- 14:34:42 ble feilen produksjonssatt

### 05.05.2020
- 09:50 - Forkuddsteamet gjorde Team dagpenger oppmerksomme på at det var mange som ble sjaltet ut fordi minstearbeidsinntekt svarte Nei. Ble påvist i [Grafanadashboard](https://grafana.adeo.no/dashboard/snapshot/fNMNpbOFEfBqVkUpgHT64Jq9zGtw4kOd) 
- 09:50 -> feilsøking, kontaktet Team inntekt, verifiserte med Skatteetaten
- 10:10 ca - Stoppe saksbehandling av dagpenger i Arena 
- 

- 11:58 ca - Saksbehandling av dapgenger i Arena ble starte opp igjen


....

- 
- 12:05 - Produksjonssetting av feilfiks
- 12:12 - Skrudde på Dapengekalkulator. Verifisert OK innhenting av inntekt igjen


## Linker

