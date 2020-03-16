# Tittel

**Dato:** 16.03.2020

**Av:** André Roaldseth

**Status:** Løst

**Sammendrag:** Applikasjonen `soknaddagpenger-server` klarte ikke å starte nye søknader.

**Konsekvens:** Det var ikke mulig å søke om dagpenger fra 17:35 til 21:25

**Rotårsaker:** Å opprette en ny søknad krever at `soknaddagpenger-server` får en ID fra `henvendelse` og oppretter en ny søknad i sin egen database.

Koden som gjør dette kjører i en alt for vid try/catch(Exception e) og lagde en feilmelding om at dette handlet om tilgangskontroll.

`soknaddapgenger-server` klarte ikke å koble seg til sin egen database.

**Utløsende faktor:** Ukjent.

**Løsning:** Restarting av `soknaddagpenger-server` og `henvendelse`

**Påvisning:** Varslet av Trudi Rød på #produksjonshendelser (p.g.a. at jeg har varsel fra Slack hver noen nevner Dagpenger)

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
| Endre feilmelding fra warning til error | Forbedring | André Roaldseth | [Utført](https://github.com/navikt/dp-soknad-server/commit/81103ba9d909a1062466c3236e05108dbdee2b42) |
| Overvåke antall søknader siste time | Forbedring ||
| Overvåke connection pool i Hikari | Forbedring ||
| Lage smartere isAlive sjekk som sjekker db tilkobling | Geir André Lund|  |    

## Hva lærte vi?

At video fungerer veldig bra til å feilsøke sammen.
At `soknaddagpenger-server` applikasjonen er ikke tilstrekkelig overvåket.

### Hva gikk bra

Et godt knippe bra folk kom fort på banen og feilsøkte problemet sammen

### Hva gikk dårlig

Ingen eksisterende overvåkning eller varsling fanget dette opp. Vi overvåker både antall feil i loggene og om endepunktene applikasjonen eksponerer svarer. Applikasjonen svarte som normalt på endepunktene vi overvåket, og feilen ble logget som en `warning`, mens alarmen ser kun etter `error` og lavere.

En feil hos BankID oppstod omtrent samtidig.

### Hvor hadde vi flaks

Det var ved opprettelse og ikke lagring av søknader at problemet oppstod.

## Tidslinje

17:25 - `soknaddagpenger-server` begynte å logge mange warnings

20:43 - Trudi Rød sier ifra på #produksjonshendelser at dagpengesøknaden gir feil

20:47 - Team Dagpenger er i gang å feilssøke

20:56 - Feil om tilgangskontroll i loggene til `soknaddagpenger-server` var funnet

21:06 - Videomøte med dagpenger og Atom. Det var ingenting som tydet på at ABAC hadde problemer

21:15 - Kilden til feilmeldinga var funnet i koden og det ble identifisert at den fanget alt for bredt, og at rotårsaken kunne være alt annet enn tilgangskontroll

21:16 - Restarting av både `soknaddagpenger-server` og `henvendelse` ble satt i gang.

21:20 - Det var mulig å starte ny søknad og tilstanden normaliserte seg.

## Linker
