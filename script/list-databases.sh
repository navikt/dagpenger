#!/bin/bash

# Script for å liste alle GCP SQL databases definert i nais.yaml filer
# med pgaudit konfigurasjon

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

echo "# Database Oversikt - GCP SQL Instances"
echo ""
echo "Generert: $(date +%Y-%m-%d)"
echo ""
echo "## Alle Databaser med pgaudit-konfigurasjon"
echo ""
echo "| # | APP | DATABASE NAME | enable_pgaudit | pgaudit.log | pgaudit.log_parameter |"
echo "|---|-----|---------------|----------------|-------------|------------------------|"

# Find all nais.yaml files with sqlInstances and extract database info
find . -name "*.yaml" \( -path "*/.nais/*" -o -name "nais.yaml" -o -name "app.yaml" \) \
  -exec grep -l "sqlInstances" {} \; 2>/dev/null | while read file; do
  
  appdir=$(echo "$file" | awk -F'/' '{print $2}')
  
  # Extract database name and pgaudit flags
  awk -v app="$appdir" '
    BEGIN { 
      dbname=""; 
      enable_pgaudit=""; 
      pgaudit_log=""; 
      pgaudit_log_param=""
      in_databases=0
    }
    /databases:/ { 
      in_databases=1
      next 
    }
    # Håndter både "- name: db" og "- envVarPrefix: DB \n name: db"
    in_databases && /name:/ && $0 ~ /name:/ { 
      gsub(/.*name: */, "")
      gsub(/"/, "")
      gsub(/^ +/, "")
      gsub(/^- /, "")
      if ($0 !~ /cloudsql|pgaudit|max_connections|bqconn/) {
        dbname=$0
      }
    }
    in_databases && /diskAutoresize/ { 
      in_databases=0 
    }
    /cloudsql\.enable_pgaudit/ { 
      getline
      if ($0 ~ /value:/) {
        gsub(/.*value: */, "")
        gsub(/"/, "")
        gsub(/^ +/, "")
        enable_pgaudit=$0
      }
    }
    /name:.*pgaudit\.log\"*$/ && !/pgaudit\.log_parameter/ { 
      getline
      if ($0 ~ /value:/) {
        gsub(/.*value: */, "")
        gsub(/"/, "")
        gsub(/'\''/, "")
        gsub(/^ +/, "")
        pgaudit_log=$0
      }
    }
    /pgaudit\.log_parameter/ { 
      getline
      if ($0 ~ /value:/) {
        gsub(/.*value: */, "")
        gsub(/"/, "")
        gsub(/^ +/, "")
        pgaudit_log_param=$0
      }
    }
    END { 
      if (dbname != "") {
        e = enable_pgaudit != "" ? enable_pgaudit : "-"
        l = pgaudit_log != "" ? pgaudit_log : "-"
        p = pgaudit_log_param != "" ? pgaudit_log_param : "-"
        print app "|" dbname "|" e "|" l "|" p
      }
    }
  ' "$file"
done | sort -u | nl -w2 -s'. ' | awk -F'. ' '{
  split($2, parts, "|")
  printf "| %s | %s | %s | %s | %s | %s |\n", $1, parts[1], parts[2], parts[3], parts[4], parts[5]
}'

echo ""
echo "## Oppsummering"
echo ""
echo "Se filen for full oversikt av alle databaser og deres pgaudit-konfigurasjon."
