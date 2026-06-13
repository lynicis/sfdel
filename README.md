<h1 align="center">sfdel</h1>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white" alt="macOS">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="License">
  <img src="https://img.shields.io/badge/script-bash-4EAA25?logo=gnu-bash&logoColor=white" alt="Bash">
  <br>
  <em>A safe, one-click script to permanently delete Safari browsing history on macOS.</em>
</p>

---

## Table of Contents

- [Quick Start](#quick-start)
- [What Gets Deleted vs. What Stays](#what-gets-deleted-vs-what-stays)
- [How It Works](#how-it-works)
- [Requirements](#requirements)
- [Detailed Usage](#detailed-usage)
- [Troubleshooting](#troubleshooting)
- [Safety Disclaimer](#safety-disclaimer)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

Download and run in one line:

```bash
curl -fsSL https://raw.githubusercontent.com/lynicis/sfdel/main/just.sh | bash
```

Or download first:

```bash
curl -fsSL -o just.sh https://raw.githubusercontent.com/lynicis/sfdel/main/just.sh
chmod +x just.sh
./just.sh
```

---

## What Gets Deleted vs. What Stays

| Deleted ❌ | Safe ✅ (not touched) |
|---|---|
| Browsing history (visited URLs) | Bookmarks |
| Visit timestamps | Saved passwords |
| | Cookies |
| | Cache |
| | Downloads list |
| | Local storage / site data |

---

## How It Works

Safari stores your browsing history in a SQLite database at `~/Library/Safari/History.db`. The script:

1. **Connects** to this database using macOS's built-in `sqlite3`.
2. **Deletes** all rows from `history_items` and `history_visits` tables.
3. **Vacuums** the database to reclaim disk space.

No other Safari data (bookmarks, passwords, cookies, etc.) is touched.

---

## Requirements

- **macOS** — This only works on macOS.
- **Full Disk Access** — Your terminal needs Full Disk Access to read Safari's database.
- **sqlite3** — Pre-installed on macOS.

### Granting Full Disk Access

1. Open **System Settings**
2. Go to **Privacy & Security** → **Full Disk Access**
3. Click **+** and add your terminal app (Terminal, iTerm2, Warp, etc.)
4. Restart your terminal

---

## Detailed Usage

1. **Close Safari** — The script tries to quit Safari automatically. If it can't, close it manually.
2. **Run the script** — See [Quick Start](#quick-start).
3. **Confirm deletion** — The script shows what it found, then asks:

   ```
   Delete all browsing history? This cannot be undone. [y/N]:
   ```

   Type `y` + **Enter** to proceed.

4. **Reopen Safari** — After deletion, the script asks if you want to reopen Safari.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `Cannot access History.db` | Grant [Full Disk Access](#granting-full-disk-access) to your terminal. |
| `Safari won't quit` | Close Safari manually, then run the script again. |
| `History is already empty` | Nothing to delete. You're all set! |
| `sqlite3 is required but not found` | Install Xcode CLI tools: `xcode-select --install` |

---

## Safety Disclaimer

- This script **permanently deletes** Safari browsing history. **It cannot be undone.**
- It **does not** delete bookmarks, passwords, cookies, cache, or any other data.
- Make backups if you're unsure.

---

## Contributing

Found a bug or have an idea? Open an [issue](https://github.com/lynicis/sfdel/issues) or submit a pull request.

---

## License

This project is open source under the [MIT License](LICENSE).

---

<p align="center">Made with ❤️ for a cleaner browsing history.</p>
