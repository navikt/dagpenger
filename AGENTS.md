# AGENTS.md — dagpenger

Dette er et **meta-repo** for Team Dagpenger i Nav. Det samler alle mikrotjenester for
behandling av dagpengesøknader under ett tak via [meta](https://github.com/mateodelnorte/meta).
Selve koden bor i hvert enkelt sub-repo; dette repoet inneholder kun konfigurasjon, skript
og verktøy for å jobbe på tvers av dem alle.

Dokumentasjon: <https://dagpenger-dokumentasjon.ansatt.nav.no/>  
Slack: `#team-dagpenger-dev` / `#team-dagpenger`  
Team: `teamdagpenger` (Nais namespace)

---

## Komme i gang

```bash
brew install nvm jq gh
git clone git@github.com:navikt/dagpenger.git
cd dagpenger
make sync          # Kloner alle sub-repoer via meta
```

```bash
make pull          # git pull --rebase --autostash på alle repoer
make build         # ./gradlew build på alle Gradle-repoer (parallelt)
make gw <target>   # Kjør vilkårlig Gradle-task på alle repoer, f.eks. make gw test
```

Hvert sub-repo har sin egen `./gradlew`-wrapper og bygges selvstendig:

```bash
cd dp-behandling
./gradlew test     # Kjør tester
./gradlew build    # Bygg
```

Node-versjon styres av [mise](https://mise.jdx.dev/) (`mise.toml` → node 24).

---

## Tech Stack

| Lag | Teknologi |
|-----|-----------|
| Backend | Kotlin 2.x, Ktor 3.x (CIO), JVM 21 (Temurin) |
| Hendelser | Kafka — Rapids & Rivers (`com.github.navikt:rapids-and-rivers`) |
| Database | PostgreSQL, Flyway, HikariCP, Kotliquery |
| Frontend | Next.js + Aksel Design System (saksbehandler / innbygger) |
| Bygg | Gradle med felles versjonskatalog i `dp-version-catalog` |
| Platform | Nais/GCP (`dev-gcp` + `prod-gcp`), namespace `teamdagpenger` |
| Auth | Wonderwall + ID-porten (innbygger), Azure AD (saksbehandler), TokenX (tjeneste-til-tjeneste) |
| Kodeformat | Spotless (Kotlin) |
| Testing | JUnit 5, Kotest assertions, MockK, Testcontainers, mock-oauth2-server |

### Felles versjonskatalog

Alle backend-repoer bruker `dp-version-catalog` (`gradle/libs.versions.toml`).
Oppdater versjoner der — ikke i hvert enkelt repo. Dependabot plukker opp endringer.

Viktige bundles:

```toml
ktor-server   = [server, auth, auth-jwt, content-negotiation, status-pages, serialization-jackson]
ktor-client   = [auth-jvm, cio, jackson, logging-jvm, content-negotiation]
postgres      = [flyway, flyway-postgres, hikari, postgresql-driver, kotlinquery]
postgres-test = [testcontainer, testcontainer-postgresql]
```

---

## Prosjektstruktur

```text
.github/                         # Copilot-instruksjoner, agent-definisjoner, workflows
  agents/                        # Domene-agenter (auth, kafka, nais, observability …)
  copilot-instructions.md
  copilot-review-instructions.md
actions/                         # Gjenbrukbare GitHub Actions
bin/                             # Shell-skript brukt av Makefile / meta
dp-version-catalog/              # Felles Gradle-versjonskatalog (libs.versions.toml)
dp-service-template/             # Mal for nye tjenester
dp-biblioteker/                  # Delte Kotlin-biblioteker (ktor-client-auth, pdl-klient …)

# Kjerne-domene
dp-behandling/                   # Vedtaksbehandling (Kotlin + Rapids & Rivers)
dp-soknad/                       # Søknadsmottak og orkestrering
dp-soknad-orkestrator/
dp-mottak/                       # Journalpost-mottak
dp-meldekortregister/            # Meldekortregistrering
dp-rapportering/                 # Rapporteringstjeneste

# Behov-løsere (event-drevne)
dp-behov-journalforing/
dp-behov-pdf-generator/
dp-behov-soknad-pdf/
dp-behov-distribuering/
dp-behov-send-til-ka/
dp-behovsakkumulator/

# Oppslag / integrasjoner
dp-oppslag-inntekt/
dp-oppslag-person/
dp-oppslag-arbeidssoker/
dp-oppslag-vedtak/
dp-oppslag-ytelser/
dp-inntekt/
dp-inntekt-klassifiserer/

# Frontender
dp-saksbehandling-frontend/      # Next.js — saksbehandler (Azure AD)
dp-mine-dagpenger-frontend/      # Next.js — innbygger (ID-porten)
dp-rapportering-frontend/
dp-rapportering-saksbehandling-frontend/
dp-brukerdialog-frontend/

# Regelmotor (eldre)
dp-regel-api/
dp-regel-grunnlag/
dp-regel-minsteinntekt/
dp-regel-periode/
dp-regel-sats/

# Infrastruktur / verktøy
dagpenger-iac/                   # IaC (Terraform e.l.)
dp-kafka-connect/
dp-kafka-connect-operator/
dp-audit-logger/
dp-aktivitetslogg/
dp-mellomlagring/
dp-varsel/
```

---

## Nais-mønstre

Alle tjenester deployes til `dev-gcp` og `prod-gcp`.  
Manifest ligger i `.nais/nais.yaml` med miljø-variabler i `.nais/vars-dev.yaml` / `vars-prod.yaml`.

### Typisk manifest (liten tjeneste)

```yaml
apiVersion: nais.io/v1alpha1
kind: Application
metadata:
  name: dp-<navn>
  namespace: teamdagpenger
spec:
  image: "{{image}}"
  port: 8080
  startup:
    path: /isalive
    initialDelay: 10
    failureThreshold: 6
    periodSeconds: 5
  liveness:
    path: /isalive
    failureThreshold: 6
    periodSeconds: 10
  readiness:
    path: /isready
    failureThreshold: 3
    periodSeconds: 10
  prometheus:
    enabled: true
    path: /metrics
  replicas:
    min: 2
    max: 4
  resources:
    requests:
      cpu: 20m
      memory: 256Mi
    limits:
      memory: 512Mi          # Aldri CPU-limit
  observability:
    logging:
      destinations:
        - id: loki
  env:
    - name: JDK_JAVA_OPTIONS
      value: -XX:+UseParallelGC -XX:MaxRAMPercentage=25.0 -XX:ActiveProcessorCount=4
```

### Auth

| Brukertype | Mekanisme | Nais-config |
|------------|-----------|-------------|
| Innbygger (browser) | ID-porten + Wonderwall | `idporten.enabled: true` / `wonderwalled-idporten` i accessPolicy |
| Saksbehandler (browser) | Azure AD + Wonderwall | `azure.application.enabled: true` |
| Tjeneste-til-tjeneste (med brukerkontext) | TokenX | `tokenx.enabled: true` |
| Tjeneste-til-tjeneste (batch/maskin) | Azure AD client_credentials | `azure.application.enabled: true` |

---

## CI/CD

Alle repoer bruker en felles GitHub Actions-mal:

```yaml
jobs:
  build:                              # Gradle build + dependency-graph
  deploy-dev:                         # nais/deploy → dev-gcp (kun main-branch)
  deploy-prod:                        # nais/deploy → prod-gcp (kun main-branch)
```

- Docker-image bygges med `nais/docker-build-push@v0`, team = `teamdagpenger`
- Deploy bruker `nais/deploy/actions/deploy@v2`
- Java-versjon: 21 (Temurin)
- Gradle caching via `gradle/actions/setup-gradle@v5` (kryptert med `GRADLE_ENCRYPTION_KEY`)

---

## Databasemønstre

```kotlin
// HikariCP — bruk lav pool-størrelse i containere
HikariDataSource().apply {
    maximumPoolSize = 3       // IKKE default 10
    minimumIdle = 1
    connectionTimeout = 10_000
    idleTimeout = 300_000
    maxLifetime = 1_800_000
    transactionIsolation = "TRANSACTION_READ_COMMITTED"
}
```

- Migrasjoner med Flyway (`db/migration/V__*.sql`)
- SQL via Kotliquery — aldri string-konkatenering i queries
- Testcontainers for integrasjonstester mot ekte PostgreSQL

---

## Code Style

### Minimal Editing

When fixing a bug or implementing a feature, change only what is necessary.
Do not rename variables, restructure working code, or refactor beyond the task at hand.
Keep diffs small and focused so they are easy to review.

### Kotlin

- Kotest matchers (`shouldBe`) i tester
- Sealed classes for tilstandsmodellering
- Parameterisert SQL — aldri string-konkatenering
- Spotless formatter — kjør `./gradlew spotlessApply` før commit

---

## Git Workflow

- **Branching**: feature-branches + PR mot `main`
- **Merge til main** trigger bygg + deploy til dev og prod
- Bruk `make check-if-up-to-date` for å verifisere at alle repoer er synkronisert
- Dependabot håndterer avhengighetsoppdateringer (koordinert via `dp-version-catalog`)

---

## Boundaries

### ✅ Always

- Kjør tester etter endringer (`./gradlew test`)
- Følg eksisterende mønstre i det aktuelle sub-repoet
- Bevar kodestruktur — ikke reorganiser utenfor oppgaven
- Valider all ekstern input
- Bruk parameterisert SQL
- Sett `AccessPolicy` eksplisitt i Nais-manifest

### ⚠️ Ask First

- Endre auth-mekanisme
- Legge til nye avhengigheter (vurder `dp-version-catalog` først)
- Endre databaseskjema (krever Flyway-migrasjon)
- Endre Kafka-topikkonfigurasjon

### 🚫 Never

- Commit secrets eller credentials
- Logg fnr, navn eller andre personopplysninger — bruk sakId
- Sett CPU-limit i Nais (kun requests)
- Bruk Azure client_credentials når brukerkontext finnes (bruk TokenX)
- Hopp over inputvalidering på eksterne grenser
