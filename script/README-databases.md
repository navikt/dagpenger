# Database Oversikt Scripts

Scripts for å liste alle GCP SQL databases definert i nais.yaml filer.

## Filer

- `list-databases.sh` - Bash script for å ekstrahere database info (best for markdown)
- `extract-database-info.py` - Python script med støtte for flere formater
- `../database-oversikt.md` - Generert oversikt (markdown)

## Bruk

### Bash versjon (anbefalt for markdown)

```bash
# Generer markdown rapport
./script/list-databases.sh > database-oversikt.md

# Vis i terminal
./script/list-databases.sh
```

### Python versjon

Python-scriptet støtter flere formater:

```bash
# Markdown format (default)
./script/extract-database-info.py > database-oversikt.md
./script/extract-database-info.py --format markdown

# Slack-vennlig format
./script/extract-database-info.py --format slack
./script/extract-database-info.py -f slack

# Se hjelpetekst
./script/extract-database-info.py --help
```

## Output

### Markdown format

Genererer en komplett markdown fil med:

1. Fullstendig tabell over alle databaser med pgaudit-konfigurasjon
2. Oppsummering av antall databaser
3. Liste over databaser med pgaudit aktivert
4. Liste over databaser uten pgaudit

Eksempel:

```markdown
| # | APP | DATABASE NAME | enable_pgaudit | pgaudit.log | pgaudit.log_parameter |
|---|-----|---------------|----------------|-------------|------------------------|
| 1 | dp-behandling | behandling | true | write,ddl,role | on |
```

### Slack format

Genererer en Slack-vennlig melding med:

- Emoji-ikoner for rask oversikt (🔒, 📝, ⚠️)
- Kompakt formatering
- Gruppering etter pgaudit-status
- Tidstempling

Eksempel:

```
*Database Oversikt - GCP SQL Instances*
📊 *Oppsummering:*
• Totalt: 16 databaser
• Med pgaudit: 7 databaser ✅

*✅ Databaser med pgaudit aktivert (7):*
  🔒 `dp-behandling` → `behandling` (full logging)
  📝 `dp-mottak` → `mottak` (write only)
```

## Krav

- **Bash script**: Bash, awk, find, grep
- **Python script**: Python 3.6+
- Må kjøres fra repository root

## Notater

- Bash-scriptet er raskere og mer stabilt for store repositories
- Python-scriptet gir flere formateringsalternativer
- Begge scripts bruker samme logikk for å finne databaser
