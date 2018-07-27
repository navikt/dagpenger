# language: no
Egenskap: Rute journalposter fra Joark
  For å behandle søknader
  må vi berike de med journalførende enhet

  De som ikke skal behandles automatisk skal gå til manuell journalføringsoppgave i GSAK

  Bakgrunn:
    Gitt vi har mottatt en hendelse for mottatt journalpost
    Og den gjelder person 71127406744
    Og ble mottatt 2012-04-12
    Og har brevkode 196002

  Scenario: Journalposter med Journalførende enhet Arena
    Når en journalpost kommer
    Og den har Arena som journalførende enhet
    Så skal den gå videre

  Scenario: Journalposter med annen Journalførende enhet
    Når en journalpost kommer
    Og den har journalførende enhet som ikke er Arena
    Så skal det opprettes BehandleHenvendelse i GSAK
