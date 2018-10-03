# language: no
Egenskap: Bruker søker om gjenopptak av tidligere dagpengeperiode

  Scenariomal: Bruker har tidligere sak å gjenoppta
    Gitt at bruker har søkt om gjenopptak av dagpenger <rettighetstype>
    Og at bruker har en sak å gjenoppta
    Og at bruker har <diskresjonskode>
    Når vi behandler journalføringen
    Så knyttes journalpost til eksisterende gsak
    Og journalpost ferdigstilles
    Og oppgave "Behandle Henvendelse" opprettes på <benk>

    Eksempler:
      | rettighetstype    | diskresjonskode | benk |
      | uten permittering | ikke            | 4450 |
      | ved permittering  | ikke            | 4455 |
      | uten permittering | 6,7             | 4499 |
      | ved permittering  | 6,7             | 4499 |

  Scenario: Bruker har ikke tidligere sak å gjenoppta
    Gitt at bruker har søkt om gjenopptak av dagpenger
    Og bruker ikke har en sak å gjenoppta
    Når vi behandler journalføringen
    Så opprettes det en manuell journalføringsoppgave i Gosys
