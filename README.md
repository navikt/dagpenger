# Dagpenger

En samling mikrotjenester for å behandle Dagpenger.

# Komme i gang

[repo](https://source.android.com/setup/develop/repo) brukes til å sette opp
repositories for alle microservicene. Det kan [innstalleres
manuelt](https://source.android.com/setup/build/downloading) eller via homebrew

`brew install repo`

Repositoriene settes opp med:

```
mkdir dagpenger
cd dagpenger
repo init -u https://github.com/navikt/dagpenger.git
repo sync
repo start --all master
```

Nå kan git brukes som normalt for hvert repo.

Se [repo siden](https://source.android.com/setup/develop/repo) for flere kommandoer.

## IntelliJ  og ktlint


Vi bruker klint for å ha formatteringsregler på koden.

Kjør:

`./gradlew klintIdea` for å oppdatere IntelliJ med klint regler. Restart IntelliJ

Deretter åpner du prosjektet i IntelliJ

## Bygg

Gradle brukes som byggverktøy og er bundlet inn. Composite build brukes for
å unngå å bygge nye versjoner av fellesbibliotekene på nytt hver gang, men løses
automatisk av Gradle.

`./gradlew build`

---

# Håndtering av gradle avhengigheter


En del felles versjonerte avhengigheter for mikrotjenestene i monorepoet er definert i [.service-template/buildSrc/src/main/kotlin/Constants.kt](.service-template/buildSrc/src/main/kotlin/Constants.kt).
For å ta i bruk felles versjonerte avhengigheter for en ny mikrotjeneste må en legge til `copyfile` innslag i [default.xml](default.xml) for gitt mikrotjeneste, eksemplifisert:

```xml
 <project name="dp-inntekt-api">
        <copyfile src="../.service-template/CODEOWNERS" dest="dp-inntekt-api/CODEOWNERS"/>
        <copyfile src="../.service-template/buildSrc/build.gradle.kts" dest="dp-inntekt-api/buildSrc/build.gradle.kts" />
        <copyfile src="../.service-template/buildSrc/settings.gradle.kts" dest="dp-inntekt-api/buildSrc/settings.gradle.kts" />
        <copyfile src="../.service-template/buildSrc/src/main/kotlin/Constants.kt" dest="dp-inntekt-api/buildSrc/src/main/kotlin/Constants.kt" />
    </project>
```

## Oppdatere avhengigheter

1. Oppdater/endre i  [.service-template/buildSrc/src/main/kotlin/Constants.kt](.service-template/buildSrc/src/main/kotlin/Constants.kt)
2. Sjekk inn og push endringen
3. Kjør `repo sync` for synkronisere `buildSrc` filene til mikrotjenestene.
4. Bygg og sjekk inn `buildSrc` filene for mikrotjenestene.


# Teste lokalt med docker-compose

Se [Docker-compose](docker-compose/README.md) for prosjektet

# Architectural Decision Log

Se [Architectural Decision Log](docs/adr/index.md) for prosjektet

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
