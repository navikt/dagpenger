# Dagpenger

En samling mikrotjenester for å behandle Dagpenger.

# Komme i gang

[meta](https://github.com/mateodelnorte/meta) brukes til å sette opp repositories for alle microservicene.

For å gjøre det litt enklere å komme i gang finnes det en [Makefile](Makefile)
som setter opp `meta` og automatiserer. Du kan også installere `meta` globalt med `npm install -g meta`.

```
brew install nvm jq gh
git clone git@github.com:navikt/dagpenger.git
cd dagpenger
make sync
```

Nå kan git brukes som normalt for hvert repo.

Se [meta](https://github.com/mateodelnorte/meta) for flere kommandoer.

---

# Håndtering av gradle avhengigheter

En del felles versjonerte avhengigheter for mikrotjenestene i monorepoet er definert i [.service-template/buildSrc/src/main/kotlin/Constants.kt](.service-template/buildSrc/src/main/kotlin/Constants.kt).

Make vil holde [enkelte filer](Makefile) i synk med tilsvarende filer i [.service-template](.service-template).

## Oppdatere avhengigheter

1. Oppdater/endre i [.service-template/buildSrc/src/main/kotlin/Constants.kt](.service-template/buildSrc/src/main/kotlin/Constants.kt)
2. Sjekk inn og push endringen
3. Kjør `make sync-template` for synkronisere `buildSrc` filene til mikrotjenestene.
4. Bygg og sjekk inn `buildSrc` filene for mikrotjenestene.

# Architectural Decision Log

Se [Architectural Decision Log](docs/adr/index.md) for prosjektet

# Henvendelser

Spørsmål knyttet til koden eller prosjektet kan rettes mot:

* André Roaldseth, andre.roaldseth@nav.no
* #team-dagpenger-dev på Slack
* Eller en annen måte for omverden å kontakte teamet på

## For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #team-dagpenger.

# HOWTO

## Oppdatere Gradle for alle prosjekter i monorepeoet

Stå i rotkatalogen og kjør:

```bash
 export GRADLE_VERSION=xxxx && make update-gradle
```

Sjekk inn og push filer som er endret.

## Koble til on prem databaser

For å koble på en dev-database via naisdevice, skal man bruke hostname dev-pg.intern.nav.no (må ikke brukes for applikasjoner, det er kun for naisdevice-tilgang). 
For produksjon, må man i naisdevice aktivere gatewayen "postgres-prod", og så koble seg på basen via host prod-pg.intern.nav.no.

```
psql -d dp-arena-sink -h prod-pg.intern.nav.no -U <POSTGRES_READ_BRUKER_FRA_VAULt>  

```
### Nye databaser on prom 
For å få tilgang til databasen fra naisdevice, må man whiteliste den i database-iac, og det gjør man ved å legge til
```
  naisdevice:
    enabled: true
``` 

(Se https://github.com/navikt/database-iac/blob/master/config/preprod-fss4-this-cluster-is-full-use-nr-5.yml#L22)
Før man legger til det på databasen sin, må man kjøre en liten risikovurdering sammen med @leif.tore.lovmo.

