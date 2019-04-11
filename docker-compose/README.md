# Dagpenger-E2E

End to End testing


##  Running LEL 1 2019 apper med docker-compose

### Kom i gang

#### Nøkler:

For at appene skal kunne kommunisere med vtpmock over SSL samt for å signere JWT´er med mock-STS må det genereres noen nøkler.
Dette kan gjøres ved å kjøre `./makekeystore.sh`

#### Bygging og start

Fra docker-compose katalogen, kjør skriptet:
 
 `./build-and-run-lel.sh up &`


alternativt

LEL 1 appenen må foreløpig bygges lokalt, ved å gå i hver enkelt prosjekt: `./gradlew assemble` eller 
`for i in ./dp*/; do (print $i && cd $i && ./gradlew assemble); done`

Start docker-compose via: 

`docker-compose -f docker-compose-lel.yml up -d  --remove-orphans --force-recreate --build`

Stop docker-compose med: 

`./build-and-run-lel.sh down`

#### Test av dp-regel-api-arena-adapter

dp-regel-api-arena-adapter benytter p.t. av jwt og en må lage en token: 

Lag et accessToken for "igroup" systembruker (NB: vtpmock.local speiler per nå Issuer fra url.
Issuer er konfigurert til å måtte være https://vtpmock.local..., så url må være https://vtpmock.local, altså må 127.0.0.1 vtpmock.local inn i etc/hosts)

`TOKEN=$(curl -k --user igroup:blabla https://vtpmock.local:8063/stsrest/rest/v1/sts/token | jq -r '.access_token')` (NB: installer jq hvis du ikke har det: `brew install jq` elns)

kall videre med tokenet mot dp-regel-api-arena-adapter:

`curl -v -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json"  http://127.0.0.1:8093/v1/minsteinntekt -d @mi.json | jq`

eksempel mi.json:

```@json

{
  "aktorId" : "12345",
  "vedtakId" : 12345,
  "beregningsdato" : "2019-05-01"
}
```

NB - inntekt-api har ikke testscenarier enda.


