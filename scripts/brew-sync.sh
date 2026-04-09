#!/bin/bash
# Compares brew list --installed-on-request against Brewfile
# and adds any new explicitly installed packages to Brewfile

set -euo pipefail

BREWFILE="${1:-$(dirname "$0")/../Brewfile}"
BREWFILE=$(realpath "$BREWFILE")

echo "Syncing against: $BREWFILE"

# Packages in Brewfile
brewfile_formulae=$(grep '^brew "' "$BREWFILE" | sed 's/brew "//;s/".*//' | sort)
brewfile_casks=$(grep '^cask "' "$BREWFILE" | sed 's/cask "//;s/".*//' | sort)

# Packages explicitly installed
installed_formulae=$(brew list --installed-on-request 2>/dev/null | sort)
installed_casks=$(brew list --casks 2>/dev/null | sort)

# Find new ones not in Brewfile
new_formulae=$(comm -23 <(echo "$installed_formulae") <(echo "$brewfile_formulae"))
new_casks=$(comm -23 <(echo "$installed_casks") <(echo "$brewfile_casks"))

if [[ -z "$new_formulae" && -z "$new_casks" ]]; then
  echo "Brewfile is up to date. Nothing new to add."
  exit 0
fi

echo ""
if [[ -n "$new_formulae" ]]; then
  echo "New formulae not in Brewfile:"
  echo "$new_formulae" | while read -r pkg; do echo "  brew \"$pkg\""; done
fi

if [[ -n "$new_casks" ]]; then
  echo "New casks not in Brewfile:"
  echo "$new_casks" | while read -r pkg; do echo "  cask \"$pkg\""; done
fi

echo ""
read -rp "Add these to Brewfile? [y/N] " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

# Append new formulae
if [[ -n "$new_formulae" ]]; then
  echo "" >> "$BREWFILE"
  echo "# ── Auto-added $(date '+%Y-%m-%d') ──────────────────────────────────────────────────" >> "$BREWFILE"
  echo "$new_formulae" | while read -r pkg; do
    echo "brew \"$pkg\"" >> "$BREWFILE"
    echo "  added: brew \"$pkg\""
  done
fi

# Append new casks
if [[ -n "$new_casks" ]]; then
  [[ -z "$new_formulae" ]] && echo "" >> "$BREWFILE"
  echo "$new_casks" | while read -r pkg; do
    echo "cask \"$pkg\"" >> "$BREWFILE"
    echo "  added: cask \"$pkg\""
  done
fi

echo ""
echo "Done. Review and organize $BREWFILE as needed."
