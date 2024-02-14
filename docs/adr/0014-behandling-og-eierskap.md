---
layout: page
title: Template
parent: ADR
nav_order: 3
has_children: false
---

# Hvor skal eierskap av behandling ligge?

* Status: proposed
* Deciders: André Roaldseth, Marius Eriksen, Knut M. Kriise, Geir A. Lund, Mona Kjeldsrud
* Date: 13.02.2024

Technical Story:

Dro fram fra diskusjon på [Slack #team-dagpenger-vedtaksmodell](https://nav-it.slack.com/archives/C063581H0PR/p1707728102581999?thread_ts=1707727491.574569&cid=C063581H0PR)

> **_Diskusjonspunkter:_**

> En "behandling" starter så snart det kommer en hendelse som skal behandles, i første omgang "søknad innsendt". 

> En er behandling av hendelsen - altså fra noe vedtaksverdig skjer til vi fatter vedtak. Målet må være at denne behandlingen klarer å gjøre alt på egenhånd, men tidvis (ganske ofte) må vi få hjelp fra saksbehandlere.

> Så finnes det en annen behandling som rammer inn hva bruker gjør. Kan kanskje også fort kalles oppgave? Men vi har mange ulike typer oppgaver. Men noe som er nærmere og fungerer som en innramming av det saksbehandler gjør.


## Beslutning

I dag har vi to repositories:

[dp-vedtak](https://github.com/navikt/dp-vedtak)
Som vi mener burde bli renamet *dp-behandling* og har ansvar for 
- reagere på behandlingsverdige hendelser
- å starte behandling
- si ifra når behandling er opprettet
- si ifra når behandling er ferdig (Forslag til vedtak?)

[dp-behandling](https://github.com/navikt/dp-behandling)
Som vi mener burde bli renamet *dp-saksbehandling* og har ansvar for
- spisset mot saksbehandlerflate
- å gi saksbehandler mulighet til å se hva som er behandlet
- opprette oppgaver for saksbehandler


