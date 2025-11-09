# OneDrive → USB Sync (PowerShell)

![GitHub release (latest by date)](https://img.shields.io/github/v/release/YOURUSER/onedrive-usb-sync)
![PowerShell Gallery](https://img.shields.io/badge/PowerShell-7%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Runs on](https://img.shields.io/badge/Windows-10%20%7C%2011-informational)

A tiny, battle-tested PowerShell script to **incrementally back up your OneDrive** to a **USB drive**.  
No full re-copy, no drama — just *new/changed* files synced quickly. Perfect for “throw it on the stick and go.”

> **Highlights**
> - 🚀 Incremental copy (fast) using `robocopy`
> - 🔒 Skips OneDrive lock/hidden/system files
> - 🧾 Clean logs per run
> - 🧩 Optional mirroring (delete on USB if removed in OneDrive)
> - 🏷️ Drive letter changed? Support for auto-detect by volume label (optional)

---

## ✨ Demo
> _Add a short screen capture (10–20s) running the script in Terminal or double-clicking a shortcut._  
> Example filename: `assets/demo.gif`

---

## 📁 Installation

1. **Download** or clone this repo.
2. Put the script somewhere tidy, e.g. `C:\Tools\onedrive-usb-sync\src\Sync-OneDriveToUSB.ps1`.
3. (Optional) Create a **desktop shortcut**:

   ```text
   powershell.exe -ExecutionPolicy Bypass -NoLogo -NoProfile -File "C:\Tools\onedrive-usb-sync\src\Sync-OneDriveToUSB.ps1" -Source "C:\Users\<you>\OneDrive - <Org>" -Dest "D:\College"
