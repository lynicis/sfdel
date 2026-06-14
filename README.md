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

- [About The Project](#about-the-project)
  - [What Gets Deleted vs. What Stays](#what-gets-deleted-vs-what-stays)
  - [How It Works](#how-it-works)
- [Prerequisites](#prerequisites)
  - [Granting Full Disk Access](#granting-full-disk-access)
- [Installation](#installation)
  - [Homebrew](#homebrew)
  - [Manual](#manual)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Safety Disclaimer](#safety-disclaimer)
- [Contributing](#contributing)
- [License](#license)

---

## About The Project

`sfdel` is a lightweight, secure shell script designed to permanently wipe your Safari browsing history on macOS without touching other browsing data like cookies, cache, or saved passwords. 

### What Gets Deleted vs. What Stays

| Deleted ❌ | Safe ✅ (not touched) |
| :--- | :--- |
| Browsing history (visited URLs) | Bookmarks |
| Visit timestamps | Saved passwords |
| | Cookies |
| | Cache |
| | Downloads list |
| | Local storage / site data |

### How It Works

Safari stores your browsing history in a SQLite database located at `~/Library/Safari/History.db`. The script performs the following actions:

1. **Checks/Quits Safari**: Ensures Safari is not actively writing to the database by offering to quit it.
2. **Database Connection**: Establishes a connection using macOS's built-in `sqlite3` CLI.
3. **Targeted Deletion**: Runs SQL commands to truncate `history_items` (unique URLs) and `history_visits` (visit timestamps/metadata).
4. **Database Vacuuming**: Executes the `VACUUM` command to completely rebuild the database file, reclaiming empty space and ensuring zero trace of deleted records.

---

## Prerequisites

- **macOS**: This tool is designed exclusively for macOS.
- **sqlite3**: Pre-installed on macOS by default.
- **Full Disk Access**: Your terminal needs Full Disk Access to modify Safari's SQLite database.

### Granting Full Disk Access

To allow `sfdel` to access Safari's history database:

1. Open **System Settings**.
2. Navigate to **Privacy & Security** → **Full Disk Access**.
3. Click the **+** button.
4. Add your preferred terminal application (e.g., Terminal, iTerm2, Warp, Ghostty).
5. Restart your terminal.

---

## Installation

### Homebrew

Install via Homebrew tap:

```bash
# Tap the repository
brew tap lynicis/tap

# Install sfdel
brew install sfdel
```

Or install directly in one step:

```bash
brew install lynicis/tap/sfdel
```

### Manual

If you prefer not to use a package manager, you can install the script manually:

```bash
# Download the script from GitHub releases
curl -fsSL -o sfdel "https://raw.githubusercontent.com/lynicis/sfdel/main/sfdel.sh"

# Make the script executable
chmod +x sfdel

# Move the script to a directory in your PATH (optional)
mv sfdel /usr/local/bin/
```

---

## Usage

### One-line Execution (No Install)

Run the latest version of the script immediately without installing:

```bash
curl -fsSL https://raw.githubusercontent.com/lynicis/sfdel/main/sfdel.sh | bash
```

### Installed Execution

If installed via Homebrew or placed in your `PATH`:

```bash
sfdel
```

### Command Flow

1. **Confirm deletion**: The script displays the number of unique URLs and total visits found, and prompts you:
   ```
   Delete all browsing history? This cannot be undone. [y/N]:
   ```
   Type `y` and press **Enter** to proceed.
2. **Reopen Safari**: After successful deletion, you will be prompted to reopen Safari if desired.

---

## Troubleshooting

| Problem | Cause | Solution |
| :--- | :--- | :--- |
| `[ERROR] Cannot access History.db` | Missing permissions | Grant [Full Disk Access](#granting-full-disk-access) to your terminal. |
| `[ERROR] Could not quit Safari` | Safari is frozen or unresponsive | Close Safari manually (or Force Quit), then re-run the script. |
| `[INFO] History is already empty` | No records found | Safari history is already clear. No action is needed. |
| `[ERROR] sqlite3 is required` | Missing sqlite3 utility | Install Xcode Command Line Tools: `xcode-select --install` |

---

## Safety Disclaimer

> [!WARNING]
> This script **permanently deletes** your Safari browsing history. This action **cannot be undone**.
> 
> It is highly recommended to create a backup of your `~/Library/Safari` folder before running if you have any critical data.
> 
> `sfdel` **does not** delete bookmarks, passwords, cookies, cache, or any other private data.

---

## Contributing

Contributions make the open-source community an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.

<p align="center">Made with ❤️ for a cleaner browsing history.</p>
