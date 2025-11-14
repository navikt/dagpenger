#!/usr/bin/env python3
"""
Enkel versjon - ekstrakter database informasjon fra nais.yaml filer.
Støtter både markdown og Slack-formatering.
"""

import argparse
import re
import subprocess
import sys
from datetime import datetime


def extract_databases():
    """Ekstraher database informasjon fra nais.yaml filer."""
    # Finn alle relevante yaml-filer
    cmd = r'find . -name "*.yaml" \( -path "*/.nais/*" -o -name "nais.yaml" -o -name "app.yaml" \) -exec grep -l "sqlInstances" {} \;'
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    files = [f.strip() for f in result.stdout.strip().split("\n") if f.strip()]

    databases = []

    for file_path in files:
        try:
            with open(file_path, "r") as f:
                content = f.read()

            # Check if file has sqlInstances
            if "sqlInstances" not in content:
                continue

            # Extract app name from path
            appdir = file_path.split("/")[1] if len(file_path.split("/")) > 1 else None
            if not appdir or appdir == ".":
                continue

            # Find database name - håndterer både rekkefølger
            # Pattern 1: - name: db \n envVarPrefix: DB
            # Pattern 2: - envVarPrefix: DB \n name: db
            db_match = re.search(r'databases:\s*\n\s*-\s*name:\s*["\']?([a-zA-Z0-9_-]+)["\']?\s*\n\s*envVarPrefix:\s*DB', content)
            if not db_match:
                # Prøv omvendt rekkefølge
                db_match = re.search(r'databases:\s*\n\s*-\s*envVarPrefix:\s*DB\s*\n\s*name:\s*["\']?([a-zA-Z0-9_-]+)["\']?', content)
            if not db_match:
                continue

            db_name = db_match.group(1).strip()

            # Skip config flags
            if any(
                kw in db_name
                for kw in ["cloudsql", "pgaudit", "max_connections", "bqconn"]
            ):
                continue

            # Extract pgaudit flags
            enable_pgaudit = ""
            pgaudit_log = ""
            pgaudit_log_param = ""

            enable_match = re.search(
                r'name:\s*["\']?cloudsql\.enable_pgaudit["\']?\s*\n\s*value:\s*["\']?([^"\'\n]+)',
                content,
            )
            if enable_match:
                enable_pgaudit = enable_match.group(1).strip()

            log_match = re.search(
                r'name:\s*["\']?pgaudit\.log["\']?\s*\n\s*value:\s*["\']?([^"\'\n]+)',
                content,
            )
            if log_match:
                pgaudit_log = log_match.group(1).strip().strip("'\"")

            log_param_match = re.search(
                r'name:\s*["\']?pgaudit\.log_parameter["\']?\s*\n\s*value:\s*["\']?([^"\'\n]+)',
                content,
            )
            if log_param_match:
                pgaudit_log_param = log_param_match.group(1).strip()

            databases.append(
                {
                    "app": appdir,
                    "database": db_name,
                    "enable_pgaudit": enable_pgaudit,
                    "pgaudit_log": pgaudit_log,
                    "pgaudit_log_param": pgaudit_log_param,
                }
            )
        except Exception:
            continue

    # Sort and deduplicate
    databases.sort(key=lambda x: x["app"])
    seen = set()
    unique_databases = []
    for db in databases:
        key = (db["app"], db["database"])
        if key not in seen:
            seen.add(key)
            unique_databases.append(db)

    return unique_databases


def print_markdown(databases):
    """Print database info som markdown."""
    print("# Database Oversikt - GCP SQL Instances")
    print()
    print(f"Generert: {datetime.now().strftime('%Y-%m-%d')}")
    print()
    print("## Alle Databaser med pgaudit-konfigurasjon")
    print()
    print(
        "| # | APP | DATABASE NAME | enable_pgaudit | pgaudit.log | pgaudit.log_parameter |"
    )
    print(
        "|---|-----|---------------|----------------|-------------|------------------------|"
    )

    for i, db in enumerate(databases, 1):
        e = db["enable_pgaudit"] or "-"
        l = db["pgaudit_log"] or "-"
        p = db["pgaudit_log_param"] or "-"
        print(f"| {i} | {db['app']} | {db['database']} | {e} | {l} | {p} |")

    # Statistics
    total = len(databases)
    with_pgaudit = sum(1 for db in databases if db["enable_pgaudit"])

    print()
    print("## Oppsummering")
    print()
    print(f"- **Totalt antall databaser**: {total}")
    print(f"- **Med pgaudit aktivert**: {with_pgaudit} databaser")
    print(f"- **Uten pgaudit**: {total - with_pgaudit} databaser")


def print_slack(databases):
    """Print database info i Slack-vennlig format."""
    total = len(databases)
    with_pgaudit = sum(1 for db in databases if db["enable_pgaudit"])
    without_pgaudit = total - with_pgaudit

    print("Database Oversikt - GCP SQL Instances")
    print(f"_Generert: {datetime.now().strftime('%Y-%m-%d %H:%M')}_")
    print()
    print("📊 Oppsummering:")
    print(f"• Totalt: {total} databaser")
    print(f"• Med pgaudit: {with_pgaudit} databaser ✅")
    print(f"• Uten pgaudit: {without_pgaudit} databaser ⚠️")
    print()

    # Databaser med pgaudit
    if with_pgaudit > 0:
        print(f"✅ Databaser med pgaudit aktivert ({with_pgaudit}):")
        for db in databases:
            if db["enable_pgaudit"]:
                log_type = db["pgaudit_log"] if db["pgaudit_log"] else "enabled"
                if log_type == "write,ddl,role":
                    log_icon = "🔒"
                    log_desc = "(full logging)"
                elif log_type == "write":
                    log_icon = "📝"
                    log_desc = "(write only)"
                else:
                    log_icon = "✓"
                    log_desc = ""
                print(f"  {log_icon} {db['app']} → {db['database']} {log_desc}")
        print()

    # Databaser uten pgaudit
    if without_pgaudit > 0:
        print(f"⚠️ Databaser uten pgaudit ({without_pgaudit}):")
        for db in databases:
            if not db["enable_pgaudit"]:
                print(f"  • {db['app']} → {db['database']}")


def main():
    """Main funksjon."""
    parser = argparse.ArgumentParser(
        description="Ekstraher database informasjon fra nais.yaml filer",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Eksempler:
  %(prog)s                    # Markdown format (default)
  %(prog)s --format markdown  # Markdown format
  %(prog)s --format slack     # Slack-vennlig format
  %(prog)s -f slack           # Kort variant
        """,
    )
    parser.add_argument(
        "-f",
        "--format",
        choices=["markdown", "slack"],
        default="markdown",
        help="Output format (default: markdown)",
    )

    args = parser.parse_args()

    databases = extract_databases()

    if args.format == "slack":
        print_slack(databases)
    else:
        print_markdown(databases)


if __name__ == "__main__":
    main()
