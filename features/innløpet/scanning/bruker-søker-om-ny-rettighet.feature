# language: no
Egenskap: Bruker søker om ny rettighet

  Scenario: Bruker har ingen sak å gjenoppta
    Gitt at bruker ikke har ingen sak å gjenoppta
    Og rettighet er <rettighetstype>
    Når vi mottar søknaden
    Så skal fagsak opprettes
    Og gsak (opprettes) knyttes til fagsak
    Og journalføring ferdigstilles
    Og oppgave "STARTV" opprettes på <benk>

  Eksempler
    | rettighetstype | benk |
    | DAGO           | 4450 |
    | PERM           | 4453 |

  Scenario: Bruker har tidligere sak som kan gjenopptas
    Gitt at bruker har en sak å gjenoppta
    Når vi mottar søknaden
    Så skal det opprettes manuell journalføringsoppgave

  Scenario: Bruker ikke finnes i Arena
    Gitt at bruker ikke finnes i Arena
    Når vi mottar søknaden
    Så skal det opprettes manuell journalføringsoppgave