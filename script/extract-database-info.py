#!/usr/bin/env python3
"""
Enkel versjon - ekstrakter database informasjon fra nais.yaml filer.
"""

import sys
import re
import subprocess
from datetime import datetime


def main():
    """Main funksjon."""
    # Finn alle relevante yaml-filer
    cmd = r'find . -name "*.yaml" \( -path "*/.nais/*" -o -name "nais.yaml" -o -name "app.yaml" \) -exec grep -l "sqlInstances" {} \;'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    files = [f.strip() for f in result.stdout.strip().split('\n') if f.strip()]
    
    databases = []
    
    for file_path in files:
        try:
            with open(file_path, 'r') as f:
                content = f.read()
            
            # Check if file has sqlInstances
            if 'sqlInstances' not in content:
                continue
            
            # Extract app name from path
            appdir = file_path.split('/')[1] if len(file_path.split('/')) > 1 else None
            if not appdir or appdir == '.':
                continue
            
            # Find database name - simplified regex
            db_match = re.search(r'-\s*name:\s*["\']?([a-zA-Z0-9_-]+)["\']?\s*\n\s*envVarPrefix:\s*DB', content)
            if not db_match:
                continue
            
            db_name = db_match.group(1).strip()
            
            # Skip config flags
            if any(kw in db_name for kw in ['cloudsql', 'pgaudit', 'max_connections', 'bqconn']):
                continue
            
            # Extract pgaudit flags
            enable_pgaudit = ""
            pgaudit_log = ""
            pgaudit_log_param = ""
            
            enable_match = re.search(r'name:\s*["\']?cloudsql\.enable_pgaudit["\']?\s*\n\s*value:\s*["\']?([^"\'\n]+)', content)
            if enable_match:
                enable_pgaudit = enable_match.group(1).strip()
            
            log_match = re.search(r'name:\s*["\']?pgaudit\.log["\']?\s*\n\s*value:\s*["\']?([^"\'\n]+)', content)
            if log_match:
                pgaudit_log = log_match.group(1).strip().strip("'\"")
            
            log_param_match = re.search(r'name:\s*["\']?pgaudit\.log_parameter["\']?\s*\n\s*value:\s*["\']?([^"\'\n]+)', content)
            if log_param_match:
                pgaudit_log_param = log_param_match.group(1).strip()
            
            databases.append({
                'app': appdir,
                'database': db_name,
                'enable_pgaudit': enable_pgaudit,
                'pgaudit_log': pgaudit_log,
                'pgaudit_log_param': pgaudit_log_param
            })
        except Exception:
            continue
    
    # Sort and deduplicate
    databases.sort(key=lambda x: x['app'])
    seen = set()
    unique_databases = []
    for db in databases:
        key = (db['app'], db['database'])
        if key not in seen:
            seen.add(key)
            unique_databases.append(db)
    
    # Print markdown table
    print("# Database Oversikt - GCP SQL Instances")
    print()
    print(f"Generert: {datetime.now().strftime('%Y-%m-%d')}")
    print()
    print("## Alle Databaser med pgaudit-konfigurasjon")
    print()
    print("| # | APP | DATABASE NAME | enable_pgaudit | pgaudit.log | pgaudit.log_parameter |")
    print("|---|-----|---------------|----------------|-------------|------------------------|")
    
    for i, db in enumerate(unique_databases, 1):
        e = db['enable_pgaudit'] or "-"
        l = db['pgaudit_log'] or "-"
        p = db['pgaudit_log_param'] or "-"
        print(f"| {i} | {db['app']} | {db['database']} | {e} | {l} | {p} |")
    
    # Statistics
    total = len(unique_databases)
    with_pgaudit = sum(1 for db in unique_databases if db['enable_pgaudit'])
    
    print()
    print("## Oppsummering")
    print()
    print(f"- **Totalt antall databaser**: {total}")
    print(f"- **Med pgaudit aktivert**: {with_pgaudit} databaser")
    print(f"- **Uten pgaudit**: {total - with_pgaudit} databaser")


if __name__ == '__main__':
    main()
