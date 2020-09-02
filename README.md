# Dagpenger

En samling mikrotjenester for å behandle Dagpenger.

# Komme i gang

[meta](https://github.com/mateodelnorte/meta) brukes til å sette opp
repositories for alle microservicene.

For å gjøre det litt enklere å komme i gang finnes det en [Makefile](Makefile)
som setter opp `meta` og automatiserer. Du kan også installere `meta` globalt
med `npm install -g meta`.

Enn så lenge må du sørge for å ha `nvm` installert (`brew install nvm`).

```
git clone git@github.com:navikt/dagpenger.git
cd dagpenger
nvm install
make sync
```

Nå kan git brukes som normalt for hvert repo.

Se [meta](https://github.com/mateodelnorte/meta) for flere kommandoer.

## IntelliJ  og ktlint

Vi bruker klint for å ha formatteringsregler på koden.

1. Installer ktlint `brew install ktlint` (sørg for at den er siste versjon, pt 0.38.1)
2. Kjør: `ktlint applyToIDEAProject ` i dagpenger katalogen for å oppdatere IntelliJ med klint regler. Restart InntelliJ etter dette
3. Legg til pre-commit hook for alle repoene ` meta exec "ktlint installGitPreCommitHook"`

## GCP

- Installer gcloud
- Legg til gcp som app i 

## Bygg

Gradle brukes som byggverktøy og er bundlet inn. Composite build brukes for
å unngå å bygge nye versjoner av fellesbibliotekene på nytt hver gang, men løses
automatisk av Gradle.

`./gradlew build`

---

# Håndtering av gradle avhengigheter

En del felles versjonerte avhengigheter for mikrotjenestene i monorepoet er definert i [.service-template/buildSrc/src/main/kotlin/Constants.kt](.service-template/buildSrc/src/main/kotlin/Constants.kt).

Make vil holde [enkelte filer](Makefile) i synk med tilsvarende filer i [.service-template](.service-template).

## Oppdatere avhengigheter

1. Oppdater/endre i [.service-template/buildSrc/src/main/kotlin/Constants.kt](.service-template/buildSrc/src/main/kotlin/Constants.kt)
2. Sjekk inn og push endringen
3. Kjør `make sync-template` for synkronisere `buildSrc` filene til mikrotjenestene.
4. Bygg og sjekk inn `buildSrc` filene for mikrotjenestene.

# Teste lokalt med docker-compose

Se [Docker-compose](docker-compose/README.md) for prosjektet

# Architectural Decision Log

Se [Architectural Decision Log](docs/adr/index.md) for prosjektet

# Hvordan vi jobber
* Nevne commits og PR i GitHub Issues
* Skrive postmortems
* Oppdatere diagrammet ved større endringer

# Henvendelser

Spørsmål knyttet til koden eller prosjektet kan rettes mot:

* André Roaldseth, andre.roaldseth@nav.no
* Eller en annen måte for omverden å kontakte teamet på

## For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #team-dagpenger.

# HOWTO

## Teste lokalt
I prosjektet finnes det en docker-compose.yml under docker-compose-kafka katalogen - kjør opp denne med `docker-compose up`

I dagpenger-joark-mottak katalogen finnes det en `DummyJoarkProducer` som en kan starte opp for å simulere journalpost hendelser - start deretter `JoarkMottak` i dagpenger-joark-mottak for å starte første ledd i innløpet.


## Oppdatere Gradle for alle prosjekter i monorepeoet

Stå i rotkatalogen og kjør:

```bash
 export GRADLE_VERSION=xxxx && ./script/update-gradle.sh
```

Sjekk inn og push filer som er endret.
