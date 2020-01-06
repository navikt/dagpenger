# Tidsavbrudd ved beregning av inngangsvilkår, sats og grunnlag for Dagpenger

**Dato:** 02.01.2020

**Av:** Geir André Lund

**Status:** Løst

**Sammendrag:** 

Tidsavbrudd ved beregning av inngangsvilkår, periode, sats og grunnlag i Arena forårsaket av problemer med å produsere melding mot Kafka. 

**Konsekvens:**

Beregning av inngangsvilkår minsteinntekt, periode, sats og grunnlag for Dagpengesaker i Arena kunne ikke behandles i perioden

**Rotårsaker:** 

Problemer med å produsere melding mot Kafka, da meldingen var over maksimal-størrelse som kan produseres (1000012 bytes - 1Mb). 
Meldingen var stor grunnet en stor inntektsfil for beregningen som igjen førte videre til at dp-datalaster-inntekt (tjenesten som henter inntekt) stoppet opp på denne meldingen og gikk inn i "retry", og som blokkerte nye beregninger fra å beregnes. 

**Utløsende faktor:** 

Stor inntektsfil (> 1MB) hentet fra inntektskomponenten. Løsningen henter inntekt for de siste 36 måneder og avhenging av hvordan arbeidsgiver rapporter inntekt kan denne bli veldig stor (https://nav-it.slack.com/archives/CA4KR8GRJ/p1578046967063500?thread_ts=1578045032.057700&cid=CA4KR8GRJ)


**Løsning:** [Hva ble løsningen?]

En foreløpig løsning var å fjerne spesifisert inntekt fra pakken, da denne ikke ble brukt. Dette gjorde at pakken ble liten nok til å kunne legges på topic. Denne løsningen er ikke tilstrekkelig over tid, da problemet fortsatt kan oppstå. Rotårsaken er ikke løst.

**Påvisning:** [Hvordan feilen ble oppdaget?]

Feilen ble ikke oppdaget av oss gjennom våre alarmer, men vi ble purret på gjennom slack av arena-ansvarlige.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| Alerts i Slack/epost/ må være reelle | Forbedring | Team dagpenger | https://github.com/navikt/dagpenger/issues/297 |
| Vi må kunne håndtere stooore inntekter | Forbedring | Team dagpenger |  https://github.com/navikt/dagpenger/issues/298 |

## Hva lærte vi?

### Hva gikk bra
* Vi hadde en midlertidig fiks før neste dag.

### Hva gikk dårlig
* Noen andre oppdaget feilen før oss, selv om våre varslinger hadde gått.

### Hvor hadde vi flaks

Vi hadde flaks at vi kunne slutte å legge på spesifisert inntekt.

## Tidslinje
|Klokkeslett | Hendelse |
|:--- |:---- |
| 15.15 | Feil påvist avslack alerts, men dette ble ikke tatt hånd om. | 
| 15.30 | Vi fikk melding på slack i #dagpenger-arena av en arena-person |
| 15.55 | Kjartan forhører seg om det finnes noen utviklere som kan ta tak i dette. |
| 21.30 |  Midlertidig fiks for denne feilen. |

## Linker
