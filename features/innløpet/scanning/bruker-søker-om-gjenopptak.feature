# language: no
Egenskap: Bruker søker om gjenopptak av tidligere dagpengerperiode

  Scenario: Bruker har tidligere sak å gjenoppta
    Gitt at bruker har en sak å gjenoppta
    Og rettighet er <rettighetstype>
    Når vi mottar søknaden
    Så skal fagsak finnes
    Og gsak (finnes) knyttes til fagsak
    Og journalføring ferdigstilles
    Og oppgave "BEHAN" opprettes på <benk>

  Eksempler
    | rettighetstype | benk |
    | DAGO           | 4450 |
    | PERM           | 4453 |

  Scenario: Bruker har ikke tidligere sak å gjenoppta
    Gitt at bruker ikke har en sak å gjenoppta
    Når vi mottar søknaden
    Så skal det opprettes manuell journalføringsoppgave