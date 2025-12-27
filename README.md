# 📱 ADB APK Manager — Ultimate Edition

![bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)
![adb](https://img.shields.io/badge/Android-ADB-3DDC84?logo=android&logoColor=white)
![linux](https://img.shields.io/badge/Linux-Supported-FCC624?logo=linux&logoColor=black)
![macos](https://img.shields.io/badge/macOS-Supported-000000?logo=apple&logoColor=white)
![wsl](https://img.shields.io/badge/WSL-Compatible-0078D4?logo=windows&logoColor=white)
![license](https://img.shields.io/badge/License-MIT-blue)

Tools wajib buat lo yang hobi gonta-ganti Custom ROM tapi males install ulang aplikasi satu-satu.  
Script Bash sederhana namun powerful untuk **Backup & Restore aplikasi Android** (termasuk Split APK / App Bundles) via ADB — **massal, cepat, anti ribet.**

---

## 🌍 Kompatibilitas
- 🐧 **Linux** (Arch / Debian)
- 🍎 **macOS** (Intel & Apple Silicon)
- 🪟 **Windows** via **WSL / Git Bash**

---

## 🔥 Fitur Andalan

### 📦 Split APK Support (Anti Force Close)
✔ Deteksi otomatis aplikasi App Bundle (Instagram, Shopee, Gojek, dll.)  
✔ Backup semua pecahan (base, config, dll) ke folder khusus  
✔ Restore pakai `adb install-multiple` → **jalan normal, tanpa FC**

---

### ⚡ Incremental Backup (Smart Skip)
⏱ Hemat waktu & kuota:

- Jika versi di HP **sama** → **SKIP**
- Jika versi beda → otomatis backup versi terbaru

🗂️ Lokasi Backup
~/Documents/APK_REPOSITORY


Format nama file:
NamaPackage_vVersi.apk

🚀 Cara Install
🔹 Cara 1 — One-Liner (paling cepat)
bash <(curl -sL https://bit.ly/adb-manager-v4)

🔹 Cara 2 — Manual
git clone https://github.com/username/adb-apk-manager.git
cd adb-apk-manager
chmod +x adb_manager.sh
./adb_manager.sh

🛠️ Prasyarat
📦 ADB
# macOS
brew install android-platform-tools

# Arch / CachyOS
sudo pacman -S android-tools

# Ubuntu / Debian
sudo apt install adb


Windows: install Android Platform Tools lalu tambahkan ke PATH.

📱 Android Device

Developer Options ON

USB Debugging ON

Gunakan kabel data yang bagus (lebih stabil)

📸 Screenshots

(tempatkan screenshot di sini)

Menu Utama

Backup Split APK

⚠️ Disclaimer

Script hanya membackup APK (installer).
Data aplikasi (login, chat, save game, dll.) tidak ikut ter-backup (non-root).

Gunakan dengan bijak — risiko ditanggung pengguna.

Made with ☕ by AwPetrik
---

### 🖥️ Multi-Platform + WSL Bridge
- Jalan native di **macOS & Linux**
- **WSL Smart Detection** → otomatis pakai `adb.exe` milik Windows  
  ➜ **tanpa ribet setup usbipd**

---

