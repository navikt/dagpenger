# Tittel

**Dato:** 19.08.2020

**Av:** Andreas Bergh

**Status:** Løst

**Sammendrag:** dp-regel-api-arena-adapter fikk ikke autorisert seg mot dp-regel-api

**Konsekvens:** Saksbehandling gjennom Arena stoppet opp i halvannen time

**Rotårsaker:** Byttet kubernetes-namespace på dp-regel-api-arena-adapter, glemte å oppdatere adresse til security-token-service som gikk mot default namespace

**Utløsende faktor:** Deploy til teamdagpenger-namespcace

**Løsning:** Oppdatere adresse til security-token-service slik den gikk mot default namespace

**Påvisning:** Varslet i en tråd på #produksjonshendelse

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |
|        |      |      |     |

## Hva lærte vi?

Dobbel og trippelsjekke adresser når man bytter namespace.
At vi ikke får nok alerts fra dp-regel-api-arena-adapter
Konfigurasjonsrammeverket vårt gjør at vi kan gå direkte inn i podden og sette ny miljøvariabel, trenger ikke hotfixe dette via deploy.

### Hva gikk bra

Feilen var lett å fikse, og ble fikset fort etter vi ble gjort oppmerksom på den

### Hva gikk dårlig

Vi burde blitt oppmerksomme på dette selv – grafanaboardene lyste rødt, men vi fikk ingen alerts. Slik fikk vi ikke varsel før 1 time og 20 minutter etter feilen startet.


### Hvor hadde vi flaks



## Tidslinje

09:55 - Deploy til teamdagpenger-namespace, feil begynner å komme

10:30 - Fjernet app fra default namespace - nå feiler alle kall mot arena-adapter.

10:45 - Tråd i #produksjonshendelser om "Brukerstøtte får inn flere saker ang feil på inntekts komponenten.  Kjent feil?"

11:11 - Bjørn Carlin gjør oss oppmerksom på at vi kan være grunn til feilen

11:17 - Årsak funnet

11:20 – Prøver å deploye hotfix, github actions / nais-deploy gjør at dette tar tid

11:34 – Fiks ute i produksjon

## Linker
