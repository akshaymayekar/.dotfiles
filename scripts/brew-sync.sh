#!/bin/bash
# Compares current brew state against Brewfile and adds any new
# taps, formulae, and casks into their respective sections.

set -euo pipefail

BREWFILE="${1:-$(dirname "$0")/../Brewfile}"
BREWFILE=$(realpath "$BREWFILE")

echo "Syncing against: $BREWFILE"

# ── Current Brewfile entries ───────────────────────────────────────────────────
brewfile_taps=$(grep '^tap "' "$BREWFILE" | sed 's/tap "//;s/".*//' | sort)
brewfile_formulae=$(grep '^brew "' "$BREWFILE" | sed 's/brew "//;s/".*//' | sort)
brewfile_casks=$(grep '^cask "' "$BREWFILE" | sed 's/cask "//;s/".*//' | sort)

# ── Currently installed ────────────────────────────────────────────────────────
installed_taps=$(brew tap 2>/dev/null | sort)
installed_formulae=$(brew list --installed-on-request 2>/dev/null | sort)
installed_casks=$(brew list --casks 2>/dev/null | sort)

# ── Diff ──────────────────────────────────────────────────────────────────────
new_taps=$(comm -23 <(echo "$installed_taps") <(echo "$brewfile_taps"))
new_formulae=$(comm -23 <(echo "$installed_formulae") <(echo "$brewfile_formulae"))
new_casks=$(comm -23 <(echo "$installed_casks") <(echo "$brewfile_casks"))

if [[ -z "$new_taps" && -z "$new_formulae" && -z "$new_casks" ]]; then
  echo "Brewfile is up to date. Nothing new to add."
  exit 0
fi

echo ""
if [[ -n "$new_taps" ]]; then
  echo "New taps not in Brewfile:"
  echo "$new_taps" | while read -r pkg; do echo "  tap \"$pkg\""; done
fi
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

# ── Insert after the last line of each type ────────────────────────────────────
insert_after_last() {
  local prefix="$1"   # e.g. 'tap "'
  local entries="$2"  # newline-separated list of raw names
  local type="$3"     # tap / brew / cask

  local last_line
  last_line=$(grep -n "^${prefix}" "$BREWFILE" | tail -1 | cut -d: -f1)

  if [[ -z "$last_line" ]]; then
    # No existing entries of this type — append at end of file
    echo "" >> "$BREWFILE"
    echo "$entries" | while read -r pkg; do
      echo "${type} \"${pkg}\"" >> "$BREWFILE"
      echo "  added: ${type} \"${pkg}\""
    done
    return
  fi

  # Build the block to insert
  local block=""
  while IFS= read -r pkg; do
    block="${block}
${type} \"${pkg}\""
    echo "  added: ${type} \"${pkg}\""
  done <<< "$entries"

  # Use a temp file to splice the lines in
  local tmp
  tmp=$(mktemp)
  awk -v line="$last_line" -v insert="$block" \
    'NR == line { print; print insert; next } { print }' \
    "$BREWFILE" > "$tmp"
  mv "$tmp" "$BREWFILE"
}

[[ -n "$new_taps" ]]     && insert_after_last 'tap "'  "$new_taps"     "tap"
[[ -n "$new_formulae" ]] && insert_after_last 'brew "' "$new_formulae" "brew"
[[ -n "$new_casks" ]]    && insert_after_last 'cask "' "$new_casks"    "cask"

echo ""
echo "Done. Review and organize $BREWFILE as needed."
