---
layout: page
title: 13.02.2020 - Manglende inntekt og vedtak LEL-løsningen (dp-regel-)
parent: Postmortems
nav_order: 3
has_children: false
---

# Manglende inntekt og vedtak LEL-løsningen (dp-regel-)

**Dato:** [13.02.2020]

**Av:** 

Geir A. Lund

**Status:** [Løst]

**Sammendrag:** 


**Avstemning**
Fikk liste over vedtak der dp-regel-api-arena-adapter APIet er brukt, avstemt den med dp-regel-api databasen:

Det mangler 745 vedtak i dp-regel-api
Disse vedtaken er fra perioden 01.07.2019 til 17.07.2019



**Årsakssammenheng** 
Vedtakene kommer via GoldenGate topicet privat-arena-dagpengevedtak-ferdigstilt. Dette topicet er ble opprettet med levetid på 1 dag. I og med at vi ikke hadde vedtakslytteren klar før 19. juli har vi dermed ikke fått markert beregningsid (inneforstått vedtakid) som brukt i dp-regel-api databasen. Vaktmesteren har dermed trodd at disse beregningsid ikke ble brukt og slettet det.




Referanse; https://github.com/navikt/dagpenger/issues/306 
