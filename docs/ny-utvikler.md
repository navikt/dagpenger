---
layout: page
title: Ny utvikler
parent: Dagpenger utviklerdokumentasjon
nav_order: 2
has_children: false
---

# Ny utvikler

## Tilganger 

- [Legg til i Teams](https://teams.microsoft.com/l/channel/19%3a78080dcbfa6d4d449642aa7c64f02a72%40thread.tacv2/General?groupId=4edb2ce5-4f0e-4f6f-9b82-b8e75e9dd09e&tenantId=62366534-1ec3-4962-8869-9b5535279d0b)
- [Sett opp 2-faktor auth](https://myaccount.microsoft.com/)
- [naisdevice](https://doc.nais.io/device/) - For diverse tilganger fra NAV eid laptop.
- Tilgang til Kibana (logger). Sjekk https://docs.nais.io/how-to-guides/observability/logs/kibana/?h=0000+ga+logganalyse#get-access-to-kibana 
- [Sikkerlogg](https://logs.adeo.no/goto/04048e28592b631c5279309c1adc00d0) - Be om tilgang til gruppen ```0000-GA-SECURE_LOG_DAGPENGER``` ved å sende mail til nav.it.identhandtering@nav.no med cc til personalleder 
- [Confluence](https://confluence.adeo.no/) - Be om tilgang til Confluence ved å sende mail til nav.it.identhandtering@nav.no med cc til personalleder

## Managed Software Center
- VMware Horizon Client
- Zoom

## Brew

Innstaller [Brew](https://brew.sh/):

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)```

Innstaller disse mest brukte programmene: 

```
brew tap boz/repo
brew install docker kail kube-ps1 kubectx kubernetes-cli maven gradle polipo nvm colima
```

Innstaller en myriade av Java-versjoner og [Jenv](https://www.jenv.be/) for å bytte mellom versjoner:

```
brew tap AdoptOpenJDK/openjdk
brew cask install jenv adoptopenjdk8 adoptopenjdk1{1,2,3,4}
```

### Colima

[Colima](https://github.com/abiosoft/colima) er alternativ til Docker desktop for å kjøre containere. (Sjekk også nais dokken https://docs.nais.io/guides/basics/?h=colima#tools-required)

For å få testcontainer til å snurre må en peke på en `DOCKER_HOST` og skru av ryuk, i din profile (`.bashrc`, `.zshrc`eller tilsvarende) eksporter disse: 

```shell

# Colima - docker host
export DOCKER_HOST=unix:///$HOME/.colima/docker.sock

# Disable ryuk - https://java.testcontainers.org/features/configuration/
export TESTCONTAINERS_RYUK_DISABLED=true
```


## Nyttige dashboards

- [GitHub Project board](https://github.com/orgs/navikt/projects/18)
- [Saksbehandling](https://grafana.adeo.no/d/QGnD4iGGz/team-dagpenger-saksbehandling?orgId=1&refresh=30s&from=now-3h&to=now)
- [Driftovervåkning](https://grafana.adeo.no/d/cpFY0XiWz/digitale-dagpenger-drift-dashboard?orgId=1&refresh=30s)
