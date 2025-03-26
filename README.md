# Dagpenger

En samling mikrotjenester for å behandle Dagpenger.

## Dokumentasjon

Ligger på https://dagpenger-dokumentasjon.ansatt.nav.no/

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

En del felles versjonerte avhengigheter for appene våre er definert i [dp-version-catalog](https://www.github.com/navikt/dp-version-catalog/blob/main/gradle/libs.versions.toml).

Make vil holde [enkelte filer](Makefile) i synk med tilsvarende filer i [.service-template](https://www.github.com/navikt/dp-version-catalog/blob/main/gradle/libs.versions.toml).

## Oppdatere avhengigheter

1. Oppdater/endre i [dp-version-catalog](https://github.com/navikt/dp-version-catalog/)
2. Sjekk inn og push endringen
3. Kjør `make sync-template` for synkronisere `buildSrc` filene til mikrotjenestene.
4. Bygg og sjekk inn `buildSrc` filene for mikrotjenestene.
5. Eventuelt la dependabot oppdatere avhengighetene i mikrotjenestene.

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

