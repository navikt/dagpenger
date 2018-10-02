#language: no
Egenskap: Bruker ettersender til søknad

  Scenario: Bruker har sak å knytte ettersending til
    Gitt at bruker har ettersendt skjema som kan knyttes til sak
    Og bruker har en sak det kan knyttes til
    Når vi behandler journalføringen
    Så knyttes journalpost til eksisterende gsak
    Og journalpost ferdigstilles
    Og oppgave "Behandle Henvendelse" opprettes på <benk>

  Scenario: Bruker har ikke sak å knytte ettersending til
    Gitt at bruker har ettersendt skjema som kan knyttes til sak
    Og bruker ikke har en sak det kan knyttes til
    Når vi behandler journalføringen
    Så opprettes det en manuell journalføringsoppgave i Gosys
