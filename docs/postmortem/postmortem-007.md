# Søknad om dagpenger har ikke generert noen oppgave til fordeling 

**Dato:** 29.01.2019

**Av:** Geir André Lund

**Status:** Pågående

**Sammendrag:** Søknad om dagpenger har ikke generert noen oppgave til fordeling 

**Konsekvens:** Blir ikke opprettet oppgaver for oppfølgning i Arena eller Gosys. Journalpost ble ikke ferdigstilt. 

**Rotårsaker:** 

 Race condition rundt når vi slo av ruting. Teorien er at man flagget “ikke behandle denne” fra kafka strømmen frem til litt før ruting ble slått av, mens de batcher, og egentlig var lengre bak enn det kafka strømmen var.

**Utløsende faktor:**  Race condition rundt når vi slo av ruting.

**Løsning:**  Spilte av joark-eventer på nytt fra 27. januar 2020 

**Påvisning:** Jira sak fra NAV kontor (https://jira.adeo.no/browse/FAGSYSTEM-95555)


## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --- |

## Hva lærte vi?

### Hva gikk bra


### Hva gikk dårlig

### Hvor hadde vi flaks

Vi kunne spille av hendelsene på nytt.

## Tidslinje

## Linker
