# Rapport – ytelsestest API for LEL-1-2019 regelberegning (dp-regel-api-arena-adapter) 

Dato: 2019-06-28

## Verktøy
Verktøy brukt for ytelsestest: siege (https://www.joedog.org/siege-faq/#). Siege er et verktøy for å stressteste og referenansemåle HTTP API'er. 



## Testrapporter


### Test nr 1.  

Beregn minsteinntekt, simulere 20 samtidige "saksbehandlere" over 30 sekunder:

```
Lifting the server siege...
Transactions:                 141 hits
Availability:               77.05 %
Elapsed time:               29.09 secs
Data transferred:            0.12 MB
Response time:                1.75 secs
Transaction rate:            4.85 trans/sec
Throughput:                0.00 MB/sec
Concurrency:                8.49
Successful transactions:         141
Failed transactions:              42
Longest transaction:            4.08
Shortest transaction:            0.01
```


Beregn dagpengegrunnlag, simulere 20 samtidige "saksbehandlere" over 30 sekunder:

```
Lifting the server siege...
Transactions:                 179 hits
Availability:              100.00 %
Elapsed time:               29.18 secs
Data transferred:            0.15 MB
Response time:                1.34 secs
Transaction rate:            6.13 trans/sec
Throughput:                0.01 MB/sec
Concurrency:                8.24
Successful transactions:         179
Failed transactions:               0
Longest transaction:            3.40
Shortest transaction:            0.24
```

I testen mot minsteinntekt ble API'et utilgjengelig. Vi kjørte samme testene flere ganger og så at dette skjedde konsekvent, da også for dagpengegrunnlag beregning. Grunnen til at API'et ble utilgjengelig var at helsesjekken til API'et ikke svarte innen tidenintervall spesifisert i NAIS plattformen. 
NAIS tar da ned instansen og starter opp en ny instans. "Requestene" som er pågående vil da feile. 
Ved undersøkelse av koden fant vi en konfigurasjonsfeil, der kodesnuttet som henter resultater fra underliggende beregninger blokkerte til de fikk svar. Det gjorde at API'et ble ikke tok i mot nye "requester" og var dermed utilgjengelig. Vi endret koden slik at den ikke lenger blokkerte. 

### Test nr 2. 

Beregn minsteinntekt, simulere 50 samtidige "saksbehandlere" over 5 minutter.

```
Lifting the server siege...
Transactions:		        2454 hits
Availability:		      100.00 %
Elapsed time:		      299.68 secs
Data transferred:	        2.09 MB
Response time:		        6.05 secs
Transaction rate:	        8.19 trans/sec
Throughput:		        0.01 MB/sec
Concurrency:		       49.54
Successful transactions:        2454
Failed transactions:	           0
Longest transaction:	       19.14
Shortest transaction:	        0.17
```

Beregn dagpengegrunnlag, simulere 50 samtidige "saksbehandlere" over 5 minutter.

```
Lifting the server siege...
Transactions:		        2479 hits
Availability:		      100.00 %
Elapsed time:		      299.53 secs
Data transferred:	        2.42 MB
Response time:		        5.96 secs
Transaction rate:	        8.28 trans/sec
Throughput:		        0.01 MB/sec
Concurrency:		       49.29
Successful transactions:        2479
Failed transactions:	           0
Longest transaction:	       13.52
Shortest transaction:	        0.14
```

Endring av koden som blokkerte gav ønsket resultat, API'et var tilgjengelig under hele testen. (Availability: 100.00 %, alle forespørsler har fått svar.) 
Svarene som tok kortest tid var 0.14 sekunder. 
De lengstventende svarene var i henholdvis 19.14 og 13.52 sekunder, noe som vi ønsker å få ned. Vi opprettet [https://github.com/navikt/dagpenger/issues/173](https://github.com/navikt/dagpenger/issues/173) for å følge opp og gjøre tiltak.

Dashboard over aktuelle tidperiode: https://grafana.adeo.no/dashboard/snapshot/Tc4xU7ITGIMNr1L45qDhWvE6GL7a4fOU?orgId=1 



