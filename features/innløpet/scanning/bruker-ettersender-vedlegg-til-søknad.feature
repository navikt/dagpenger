#language: no
Egenskap: Bruker ettersender vedlegg til søknad

  Scenario: Bruker har sak å gjenoppta
    Gitt at bruker ikke har aktiv sak fra før
    Og rettighet er <rettighetstype>
    Når vi mottar søknaden
    Så skal fagsak finnes
    Og gsak (finnes) knyttes til fagsak
    Og journalføring ferdigstilles
    Og oppgave "BEHAN" opprettes på <benk>