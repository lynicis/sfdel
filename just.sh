#!/usr/bin/env bash
#
# just.sh — delete Safari browsing history from History.db
#
# Requires: macOS, Full Disk Access granted to Terminal (or your terminal app).
#
# Deletes:  history_items (unique URLs) and history_visits (page visits).
# Does NOT delete: cookies, cache, downloads, local storage, bookmarks, etc.

set -euo pipefail

VERSION="1.0.0"
HISTORY_DB="$HOME/Library/Safari/History.db"
QUIT_WAIT_STEPS=20
QUIT_WAIT_DELAY=0.5

# --- Colors (disabled if not a terminal) ---
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    BOLD='\033[1m'
    RESET='\033[0m'
else
    RED='' GREEN='' YELLOW='' BOLD='' RESET=''
fi

info()  { printf "%s[INFO]%s  %s\n" "${GREEN}" "${RESET}" "$*"; }
warn()  { printf "%s[WARN]%s  %s\n" "${YELLOW}" "${RESET}" "$*"; }
error() { printf "%s[ERROR]%s %s\n" "${RED}" "${RESET}" "$*" >&2; }
die()   { error "$*"; exit 1; }

confirm() {
    local prompt="${1:-Continue?} [y/N]: " reply
    printf "%s%s%s" "${YELLOW}" "${prompt}" "${RESET}"
    read -r reply
    [[ "$reply" == [yY] || "$reply" == [yY][eE][sS] ]]
}

quit_safari() {
    info "Safari is running. Quitting Safari..."
    osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
    for ((i = 0; i < QUIT_WAIT_STEPS; i++)); do
        pgrep -xq "Safari" || { info "Safari closed."; return 0; }
        sleep "$QUIT_WAIT_DELAY"
    done
    die "Could not quit Safari. Please close it manually and try again."
}

# --- Version ---
if [[ "${1-}" == "--version" || "${1-}" == "-v" ]]; then
    echo "just-delete-safari-history $VERSION"
    exit 0
fi

# --- Pre-flight checks ---
[[ "$(uname)" == "Darwin" ]] || die "This script only runs on macOS."
[[ -f "$HISTORY_DB" ]] || die "History database not found at: $HISTORY_DB"
command -v sqlite3 &>/dev/null || die "sqlite3 is required but not found."

# --- Quit Safari if running ---
pgrep -xq "Safari" && quit_safari

# --- Check we can read the database (Full Disk Access test) ---
if ! sqlite3 "$HISTORY_DB" "SELECT 1;" &>/dev/null; then
    die "Cannot access History.db. Grant Full Disk Access to your terminal app:\n" \
        "    System Settings > Privacy & Security > Full Disk Access"
fi

# --- Show what will be deleted ---
ITEM_COUNT=$(sqlite3 "$HISTORY_DB" "SELECT COUNT(*) FROM history_items;" 2>/dev/null || echo "?")
VISIT_COUNT=$(sqlite3 "$HISTORY_DB" "SELECT COUNT(*) FROM history_visits;" 2>/dev/null || echo "?")

echo ""
printf "%sSafari Browsing History%s\n" "${BOLD}" "${RESET}"
echo "  Unique URLs:    $ITEM_COUNT"
echo "  Total visits:   $VISIT_COUNT"
echo ""

if [[ "$ITEM_COUNT" == "0" && "$VISIT_COUNT" == "0" ]]; then
    info "History is already empty. Nothing to delete."
    exit 0
fi

# --- Confirm ---
confirm "Delete all browsing history? This cannot be undone." || { info "Aborted."; exit 0; }

# --- Delete history ---
info "Deleting browsing history..."
sqlite3 "$HISTORY_DB" <<'SQL'
DELETE FROM history_items;
DELETE FROM history_visits;
VACUUM;
SQL
info "Browsing history deleted."

# --- Offer to reopen Safari ---
echo ""
if confirm "Reopen Safari"; then
    open -a Safari
    info "Safari reopened."
fi

echo ""
info "Done."
