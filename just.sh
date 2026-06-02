#!/usr/bin/env bash
#
# delete-safari-history.sh
#
# Deletes all browsing history from Safari's History.db on macOS.
# Requires: macOS, Full Disk Access granted to Terminal (or your terminal app).
#
# What gets deleted:
#   - history_items  (unique URLs)
#   - history_visits (individual page visits) -- cascades from history_items
#
# What is NOT deleted:
#   - Cookies, cache, downloads, local storage, bookmarks, etc.

set -euo pipefail

HISTORY_DB="$HOME/Library/Safari/History.db"

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

info()  { printf "${GREEN}[INFO]${RESET}  %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error() { printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2; }
die()   { error "$*"; exit 1; }

# --- Pre-flight checks ---

# 1. macOS only
[[ "$(uname)" == "Darwin" ]] || die "This script only runs on macOS."

# 2. History.db must exist
[[ -f "$HISTORY_DB" ]] || die "History database not found at: $HISTORY_DB"

# 3. sqlite3 must be available
command -v sqlite3 &>/dev/null || die "sqlite3 is required but not found."

# --- Quit Safari if running ---
if pgrep -xq "Safari"; then
    info "Safari is running. Quitting Safari..."
    osascript -e 'tell application "Safari" to quit' 2>/dev/null || true
    # Wait for Safari to fully close (up to 10 seconds)
    for i in {1..20}; do
        pgrep -xq "Safari" || break
        sleep 0.5
    done
    if pgrep -xq "Safari"; then
        die "Could not quit Safari. Please close it manually and try again."
    fi
    info "Safari closed."
fi

# --- Check we can read the database (Full Disk Access test) ---
if ! sqlite3 "$HISTORY_DB" "SELECT 1;" &>/dev/null; then
    die "Cannot access History.db. Grant Full Disk Access to your terminal app:\n" \
        "    System Settings > Privacy & Security > Full Disk Access"
fi

# --- Show what will be deleted ---
ITEM_COUNT=$(sqlite3 "$HISTORY_DB" "SELECT COUNT(*) FROM history_items;" 2>/dev/null || echo "?")
VISIT_COUNT=$(sqlite3 "$HISTORY_DB" "SELECT COUNT(*) FROM history_visits;" 2>/dev/null || echo "?")

echo ""
printf "${BOLD}Safari Browsing History${RESET}\n"
echo "  Unique URLs:    $ITEM_COUNT"
echo "  Total visits:   $VISIT_COUNT"
echo ""

if [[ "$ITEM_COUNT" == "0" && "$VISIT_COUNT" == "0" ]]; then
    info "History is already empty. Nothing to delete."
    exit 0
fi

# --- Confirm ---
printf "${YELLOW}Delete all browsing history? This cannot be undone. [y/N]: ${RESET}"
read -r CONFIRM
case "$CONFIRM" in
    [yY]|[yY][eE][sS]) ;;
    *) info "Aborted."; exit 0 ;;
esac

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
printf "Reopen Safari? [y/N]: "
read -r REOPEN
case "$REOPEN" in
    [yY]|[yY][eE][sS])
        open -a Safari
        info "Safari reopened."
        ;;
    *)
        ;;
esac

echo ""
info "Done."
