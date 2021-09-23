---
layout: page
title: Jenkins
parent: Howtos
nav_order: 3
has_children: false
---

# Jenkins
[dp-soknad-server](https://github.com/navikt/dp-soknad-server) bygges av Jenkinsserveren til dagpenger

## Tilgang til https://jenkins-dagpenger.adeo.no/ 

For å tilgang til https://jenkins-dagpenger.adeo.no/ må du:

1. Koble til naisdevice
2. Legg til innslag `155.55.191.16 jenkins-dagpenger.adeo.no` i `/etc/hosts` 

## SSH tilgang til jenkins-dagpenger 

1. Koble til naisdevice
2. Legg til innslag `10.92.78.58 a01apvl00128.adeo.no` i `/etc/hosts` 
3. Legg til det nedenfor i ssh config ( `~/.ssh/config` )
4. `ssh jenkins-dagpenger` , bruk ident passord
5. with great power comes great responsibility - Vit hva du gjør :-)

```bash
   Host jenkins-dagpenger
       User <DIN_IDENT>
       HostName a01apvl00128.adeo.no
```

