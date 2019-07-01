# Manglende inntekter for LEL1 2019

**Dato:** 01.07.2019

**Av:** @androa

**Status:** Pågående

**Sammendrag:** Inntekter for enkelte personer kan ikke hentes i Arena.

**Konsekvens:** All saksbehandling av Dagpenger stanset.

**Rotårsaker:** Inntektskomponenten produserte ugyldig JSON med duplikate felter. Vår JSON-parsing tillot ikke det, og feilet.

**Utløsende faktor:** Produksjonssetting av LEL1.

**Løsning:** Fjerne duplikat felt i Inntektskomponenten.

**Påvisning:** Monitorering av loggene i forbindelse med produksjonssettingen.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |

## Hva lærte vi?

### Hva gikk bra

- Loggmonitorering fungerer.

### Hva gikk dårlig

- Vi mangler automatisk varsling på feil i loggene.

### Hvor hadde vi flaks

## Tidslinje

31.06.2019

- 13:30: Produksjonssetting av LEL1 er ferdig.

01.07.2019

- 07:11: Første feil dukket opp i loggene.

- 07:54: Vi var i gang med feilssøking.

- 07:54: Feil gjenkjent fra utvikling.

- 08:18: Feil identifisert i Inntektskomponenten.

- 08:30: Incidient-kanal opprettet.

- 08:49: Løsning i Inntektskomponenten deployet i t6.

- 09:52: Feilretting verifisert i Inntektskomponenten av Team Registre, og planlagt deploy til produksjon klokken 17:00

- 09:59: Saksbehandlere får beskjed å prioritere andre ting.

- 12:41: Feilretting i Inntektskomponenten deployet til de fleste q/t-miljøer.

- 13:48: Feilårsak verifisert i t4.

- 14:51: Feilretting i Inntektskomponenten er verifisert av testere.

- 15:xx:

## Linker