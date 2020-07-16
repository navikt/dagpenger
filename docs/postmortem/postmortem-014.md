# Allerede innsendte søknader ble forsøkt migrert til nyere versjon da bruker prøvde å ettersende dokumenter

**Dato:** [15.05.2020]

**Av:** Knut M Riise

**Status:** [Løst]

**Sammendrag:**
Oppgradering av søknadsdialogen for mulighet til å migrere søknader, slik at man kunne legge på oppdaterte koronafelter i søknad uten å slette samtlige søknader, gjorde ved et uhell slik at ferdig innsendte søknader også ble migrert til ny versjon da brukere ønsket å ettersende dokumenter på en allerede innsendt søknad. Dette førte til et kresj, da den migrerte innsendte søknaden feilet valideringen, gitt at de nye feltene ikke var fyllt ut.

**Konsekvens:** Brukere hadde ikke mulighet til å ettersende dokumenter på allerede innsendte søknader i tidsrommet mellom kl 11 og kl 13 den 15. mai 2020

**Rotårsaker:** Utviklerene var ikke klar over at også ettersendingsmodulen lå inne i prosjektet hvor vi migrerte søknadene, og at migrering ble kjørt på søknader som ble hentet opp av databasen uansett om søknaden allerede var sendt inn eller ikke

**Utløsende faktor:** Feilen oppstod ved at vi ikke filtrerte vekk allerede innsendte søknader i migreringslogikken. Utløst av at bruker ønsker å starte en ettersendelse av dokumenter, som gjør at en allerede innsendt søknad blir åpnet og lest av server.

**Løsning:** Filtrere vekk allerede innsendte søknader fra migreringslogikken

**Påvisning:** Rapporter om at man ikke kunne laste opp ettersendelser ble meldt via JIRA bekreftet mistanken om at vi hadde en feil. Utviklerene holdt allerede på med debugging av feil i kibana uten å finne årsak før JIRA henvendelsen ble meldt inn.

## Aksjonspunkter

| Aksjon | Type | Eier | Referanse |
| ------ | ---- | ---- | --------- |
| ------ | ---- | ---- | ---       |
| ------ | ---- | ---- | ---       |

## Hva lærte vi?

### Hva gikk bra

### Hva gikk dårlig

### Hvor hadde vi flaks

## Tidslinje

## Linker
