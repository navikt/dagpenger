# language: no
Egenskap: Motta journalposter fra Joark
  Alle søknader, digitalt og på papir blir journalført i Joark
  For å kunne behandle de må vi laste de inn

  Scenario: Alle journalposter skal inn på vår egen kø
    Gitt at det er en journalføringspost
    Og den har tema DAG
    Og gjelder person 71127406744
    Og er mottatt 2012-04-12
    Og har brevkode 196002
    Når vi leser journalposten fra Joark kø
    Så skal det opprettes en hendelse for mottatt journalpost
    Og den skal gjelde person 71127406744
    Og være mottatt 2012-04-12
    Og ha brevkode 196002
