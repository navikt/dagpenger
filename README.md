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
repo start master
```

Nå kan git brukes som normalt for hvert repo.

## Bygg

Gradle brukes som byggverktøy og er bundlet inn. Composite build brukes for
å unngå å bygge nye versjoner av fellesbibliotekene på nytt hver gang, men løses
automatisk av Gradle.

`./gradlew build`

---

# Henvendelser

Spørsmål knyttet til koden eller prosjektet kan rettes mot:

* André Roaldseth, andre.roaldseth@nav.no
* Eller en annen måte for omverden å kontakte teamet på

## For NAV-ansatte

Interne henvendelser kan sendes via Slack i kanalen #dagpenger.

# HOWTO 

## Teste lokalt
I prosjektet finnes det en docke-compose.yml - kjør opp denne med `docker-compose up`
NB 1: - legg til `kafka` som en host i hosts fila ca sånn (i `/etc/hosts` ) :
```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost kafka
255.255.255.255	broadcasthost
::1             localhost kafka
xxxxx           <vpn ting>
```
NB 2: - BigIp driver på å overskriver `/etc/hosts` med ujevne mellomrom - det kan hende en må legge til det på nytt
I dagpenger-joark-mottak katalogen finnes det en `DummyJoarkProducer` som en kan starte opp for å simulere journalpost hendelser - start deretter `JoarkMottak` i dagpenger-joark-mottak for å starte første ledd i innløpet. 
