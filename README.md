# Dagpenger

En samling mikrotjenester for å behandle Dagpenger.

# Komme i gang

[repo](https://source.android.com/setup/develop/repo) brukes til å sette opp
repositories for alle microservicene. Det kan [innstalleres
manuelt](https://source.android.com/setup/build/downloading) eller via homebrew

`brew install repo`

NAVIKT github repositories krever SAML SSO, for å
slippe å skrive inn bruker og passord kan man generere
et [personlig access token](https://help.github.com/articles/creating-an-oauth-token-for-command-line-use)
som legges inn i  
```
~/.netrc 

machine github.com login <DITT_TOKEN>

```

Repositoriene settes opp med:

```
repo init -u https://github.com/navikt/dagpenger.git
repo sync
repo start --all master
```

Nå kan git brukes som normalt for hvert repo.

Se https://source.android.com/setup/develop/repo for flere kommandoer.

## IntellJ  og ktlint 



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
