Hva løser vi ved å lage ny søknadsdialog?
Antagelse:
Raskere utviklingstid; grunnet teknologi man kjenner, løsere kobling mellom applikasjonene og bedre domenedeling av applikasjon
Måling:
Utviklingstid på søknadsdialog - Denne målingen har vi ikke, er den verdt å fikse?
Antagelse:
Bedre kontroll på egne data, mer skreddersydd søknad for bruker -> summen av disse vil gi bedre veiledning for saksbehandler
Søknaden vil være behandlingsklar før hele søknaden er fylt ut ->
Måling:
Gjennomsnittlig utfyllingstid på søknad - Denne har vi, men måler den egentlig noe vi ønsker å måle?
Antall klagesaker - I teorien burde dette gi en god måling, da kvaliteten på vedtakene da vil ha gått opp

Hva løser vi ved å lage innsyn i egen sak?
Antagelse:
Brukere vet ikke om de er ferdige å søke
Løsning:
Notifikasjon legges på mittnav, eller veientilarbeid etter at søknad er levert
Måling:
Antall henvendelser til nks - Denne målingen har vi ikke, har PR hos modiabrukerdialog
Utfordringer:
Vi kan kun se kompletthet ved innsendingstidspunkt, vi kan ikke se ettersendelser eller om søknad er komplett
Vi viser kun notifikasjonen en gang, bruker kan bli usikker neste gang h\*n logger inn
Tilgjengelige data:
Søknad journalført ("mottatt")
Kompletthet ved søknad sendt
Ikke tilgjengelige data (enn så lenge):
Ettersendelser, og dermed kompletthet per nå
Hvor behandlingsklar søknaden er, med mindre det er antatt avslag på minsteinntekt
Om en søknad er blitt "tatt" i av saksbehandler
Om det er mangelbrev

Hva er fordelen med å legge notifikasjonen på mittnav?
Antagelse:
Enklere som en teknisk MVP, fire&forget notifikasjon som gjør at vi ikke trenger state
Utfordringer:
Vi viser kun notifikasjonen en gang
Målinger:
:shrug:

Hva er fordelen med å legge notifikasjon på veien til arbeid?
Antagelse:
Vi treffer nøyaktig de brukerene vi ønsker å treffe (søkere som har søkt, og som er aktive på)
Utfordringer:
Veientilnav bør ha state (fire&forget)
ELLER vi bør kunne vite når vi eventuelt fjerner notifikasjonen (som vi ikke kan - enda, må kunne vite når den er behandlet i arena)
Målinger:
Antall personer som klikker seg videre til "mine saker" fra notifikasjonen vår (hva måler egentlig dette?), enkelt å måle i det minste

Hvaslags informasjon får brukeren i dag?
Brukeren får i dag allerede informasjon om hvilke søknader som er innsendt, og hva de mangler av vedlegg
Antagelsen er derimot at denne informasjonen er "gjemt" slik at bruker ikke finner det, eller at de ikke sjekker og dermed glemmer å ettersende vedlegg.

Hva kan vi lese fra egne systemer?
Hvor skal vi lenke til? "dine saker", "saksoversikt/tema/DAG", eller "/saksoversikt/ettersending"??
Ferdigstilltarena og ferdigbehandlet: NaturligIdent = Fnr
Spørsmålet er om vi greier å pinne det til selve søknaden eller om dette er nok til å sende en notifikasjon til "mine saker" generelt sett

Plan:
Skrive ett domene for innsyn
Adapter som leser inn "ting" som er verdifult for innsyn: Hva? (liste)
Liste over hva som er verdifult for innsyn:

- Søknad er sendt
- Søknad er mottatt
- Søknad mangler informasjon fra deg (vedlegg)
- Søknad mangler informasjon fra arbeidsgiver
- Søknad er ikke klar til behandling
- Søknad er klar til behandling
- Søknad er #x i kø til behandling
- Søknad venter på saksbehandler
- Vedlegg er ikke godkjent
- Vedlegg er godkjent
- Søknad trenger mer informasjon etter at saksbehandler har sett på den
- Søknad har fått avslag
- Søknad har fått innvilgelse
- Søknad har en pågående klagesak
- Søknad har en ytelse knyttet til seg
  Søknad vil være mer rettet mot den "nye" prosess/saksbehandlingsflyten, Hva er minimum for ny søknad?
- Identitet på søker
- Hvilke andre pågående saker har personen i NAV (automagisk)
- Når søkes det fra
- Inntekt (automagisk)
- Arbeidsforhold?
- Fangst og fiske (kun hvis inntekt tilsier det)
- Verneplikt (Burde ikke dette være automagisk?, hva hvis inntekten er såpass høy at man får mer uansett?)
-
