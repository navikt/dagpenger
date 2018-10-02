#language: no
Egenskap: Bruker sender dokumentasjon uten NAV skjema ID

  Scenario: Bruker har sendt noe uten NAV skjema ID
    Gitt at bruker har ettersendt noe som ikke kan knyttes til sak
    Når vi behandler journalføringen
    Så opprettes det en fordelingsoppgave i Gosys
