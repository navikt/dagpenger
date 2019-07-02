# Manglende mapping av inntektstype Tips

**Dato:** 02.07.2019

**Av:** @androa

**Status:** Løst

**Sammendrag:** Inntekter for en person kunne ikke hentes i Arena.

**Konsekvens:** En sak kunne ikke behandles i en liten periode.

**Rotårsaker:** Inntektskomponenten svarte med en inntektstype (tips) vi ikke hadde
mapping for.

**Utløsende faktor:** En person med lønnstype ble behandlet.

**Løsning:** Legge inn klassifisering av inntekstype tips til arbeidsinntekt.

**Påvisning:** Automatisk varsling av feil i loggene til Slack.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
| Legge til mapping av inntektstype tips | feilretting | @geiralund | https://github.com/navikt/dp-inntekt-api/pull/47 |
| Lage issue for å gjennomgå alle mappinger på nytt | forhindre | @tonjemjovik | https://github.com/navikt/dagpenger/issues/186 |

## Hva lærte vi?

### Hva gikk bra

- Loggmonitorering fungerer.

### Hva gikk dårlig

- Vi glemte å følge opp feilen som ble identifisert 29.05.

### Hvor hadde vi flaks

- Det traff kun et subsett av brukerene.

## Tidslinje

02.07.2019

- 14:16: Første feil dukket opp i loggene.
- 14:21: Vi fikk alarm i Slack og begynte feilsøking.
- 14:23: Feil var identifisert som manglende mapping for inntektstype.
- 14:35: Vi varslet i #produksjonhendelser om problemet.
- 14:41: Feilfiks var klar.
- 14:49: Fiks var deployet til produksjon.
- 14:52: Issue for å gå gjennom alle inntektstyper på nytt ble opprettet.

## Linker
