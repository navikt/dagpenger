# Dagpenger

En samling mikrotjenester for å behandle Dagpenger.

# Komme i gang

[repo](https://source.android.com/setup/develop/repo) brukes til å sette opp
repositories for alle microservicene. Det kan [innstalleres
manuelt](https://source.android.com/setup/build/downloading) eller via homebrew

`brew install repo`

Repositoriene settes opp med:

```
repo init -u git@github.com:navikt/dagpenger.git
repo sync
repo start --all master
```

Nå kan git brukes som normalt for hvert repo.

## IntellJ  og ktlint 

Åpne prosjektet i IntelliJ 

Vi bruker klint for å ha formatteringsregler på koden. Kjør:

`./gradlew klintIdea` for å oppdatere IntelliJ med klint regler. Restart IntelliJ 

## Bygg

Gradle brukes som byggverktøy og er bundlet inn. Composite build brukes for
å unngå å bygge nye versjoner av fellesbibliotekene på nytt hver gang, men løses
automatisk av Gradle.

`./gradlew build`

---

# Architectural Decision Log

Se [Architectural Decision Log](src/docs/index.md) for prosjektet

# Henvendelser

Spørsmål knyttet til koden eller prosjektet kan rettes mot:

* André Roaldseth, andre.roaldseth@nav.no
* Eller en annen måte for omverden å kontakte teamet på

## For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #dagpenger.

# HOWTO

## Teste lokalt
I prosjektet finnes det en docker-compose.yml under docker-compose-kafka katalogen - kjør opp denne med `docker-compose up`

I dagpenger-joark-mottak katalogen finnes det en `DummyJoarkProducer` som en kan starte opp for å simulere journalpost hendelser - start deretter `JoarkMottak` i dagpenger-joark-mottak for å starte første ledd i innløpet.


## Oppdatere Gradle for alle prosjekter i monorepeoet

stå i rotkatalogen og kjør:

```bash
 export GRADLE_VERSION=xxxx && ./script/update-gradle.sh     
```

Sjekk inn og push filer som er endret. 