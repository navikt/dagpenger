# Ny utvikler

## Tilganger 

- [Legg til i Teams](https://teams.microsoft.com/l/channel/19%3a78080dcbfa6d4d449642aa7c64f02a72%40thread.tacv2/General?groupId=4edb2ce5-4f0e-4f6f-9b82-b8e75e9dd09e&tenantId=62366534-1ec3-4962-8869-9b5535279d0b)
- [Sett opp 2-faktor auth](https://myaccount.microsoft.com/)
- [naisdevice](https://doc.nais.io/device/) - For diverse tilganger fra NAV eid laptop.

## Managed Software Center
- VMware Horizon Client
- Zoom

## Brew

Innstaller [Brew](https://brew.sh/):

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)```

Innstaller disse mest brukte programmene: 

```
brew tap boz/repo
brew install docker kail kube-ps1 kubectx kubernetes-cli maven gradle polipo nvm
```

Innstaller en myriade av Java-versjoner og [Jenv](https://www.jenv.be/) for å bytte mellom versjoner:

```
brew tap AdoptOpenJDK/openjdk
brew cask install jenv adoptopenjdk8 adoptopenjdk1{1,2,3,4}
```

## Nyttige dashboards

- [GitHub Project board](https://github.com/orgs/navikt/projects/18)
- [Saksbehandling](https://grafana.adeo.no/d/QGnD4iGGz/team-dagpenger-saksbehandling?orgId=1&refresh=30s&from=now-3h&to=now)
- [Driftovervåkning](https://grafana.adeo.no/d/cpFY0XiWz/digitale-dagpenger-drift-dashboard?orgId=1&refresh=30s)
