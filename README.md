# just-delete-safari-history

![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)

> A safe, one-click script to permanently delete Safari browsing history on macOS.

---

## ⚡ Quick Start

Download and run the script in one line:

```bash
curl -fsSL https://raw.githubusercontent.com/lynicis/just-delete-safari-history/main/just.sh | bash
```

Or, if you prefer to download it first:

```bash
# Download
curl -fsSL -o just.sh https://raw.githubusercontent.com/lynicis/just-delete-safari-history/main/just.sh

# Make it executable
chmod +x just.sh

# Run it
./just.sh
```

---

## 🧹 What Gets Deleted vs. What Stays

| Deleted ❌ | Safe ✅ (not touched) |
|---|---|
| Browsing history (visited URLs) | Bookmarks |
| Visit timestamps | Saved passwords |
| | Cookies |
| | Cache |
| | Downloads list |
| | Local storage / site data |

---

## 📋 Requirements

- **macOS** — This script only works on macOS.
- **Full Disk Access** — Your terminal app needs Full Disk Access to read Safari's history database.
- **sqlite3** — Pre-installed on macOS, but make sure it's available.

### How to Grant Full Disk Access

1. Open **System Settings**
2. Go to **Privacy & Security** → **Full Disk Access**
3. Click the **+** button and add your terminal app (e.g., Terminal, iTerm2, Warp)
4. Restart your terminal

---

## 📖 Detailed Usage

1. **Close Safari** — The script will try to quit Safari automatically. If it can't, close it manually.
2. **Run the script** — See the [Quick Start](#-quick-start) section above.
3. **Confirm deletion** — The script will show how many URLs and visits it found, then ask:

   ```
   Delete all browsing history? This cannot be undone. [y/N]:
   ```

   Type `y` and press **Enter** to proceed.

4. **Reopen Safari** — After deletion, the script will ask if you want to reopen Safari.

---

## 🛠️ Troubleshooting

| Problem | Solution |
|---|---|
| `Cannot access History.db` | Grant [Full Disk Access](#how-to-grant-full-disk-access) to your terminal app. |
| `Safari won't quit` | Close Safari manually, then run the script again. |
| `History is already empty` | Nothing to delete. You're all set! |
| `sqlite3 is required but not found` | Reinstall Xcode Command Line Tools: `xcode-select --install` |

---

## ⚠️ Safety Disclaimer

- This script **permanently deletes** your Safari browsing history. **It cannot be undone.**
- It **does not** delete bookmarks, passwords, cookies, cache, or any other data.
- Always make sure you have backups if you're unsure.

---

## 🤝 Contributing

Found a bug or have an idea? Feel free to open an issue or submit a pull request.

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<p align="center">Made with ❤️ for a cleaner browsing history.</p>
