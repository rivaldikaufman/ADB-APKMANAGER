📱 ADB APK Manager — Ultimate Edition

Tools wajib buat lo yang hobi gonta-ganti Custom ROM tapi males install ulang aplikasi satu-satu.
Script Bash sederhana namun powerful untuk Backup & Restore aplikasi Android (termasuk Split APK / App Bundles) secara massal via ADB.

Didesain berjalan mulus di:

🐧 Linux (Arch / Debian)

🍎 macOS (Intel & Apple Silicon)

🪟 Windows via WSL / Git Bash

🔥 Fitur Andalan
📦 Split APK Support (Anti Force Close)

Deteksi otomatis aplikasi modern (Instagram, Shopee, Gojek, dll.) yang pakai App Bundle.

Backup semua pecahan APK (base, config, dll) ke folder khusus.

Restore pakai adb install-multiple — aplikasi jalan normal, tanpa FC.

⚡ Incremental Backup (Smart Skip)

Hemat waktu & kuota:

Jika versi di HP sama → SKIP (tidak download ulang)

Jika ada update → script otomatis backup versi terbaru.

🖥️ Multi-Platform + WSL Bridge

Jalan native di macOS & Linux.

WSL Smart Detection: kalau jalan di WSL, script otomatis pakai adb.exe dari Windows.
➜ Tanpa ribet setup usbipd!

🗂️ Centralized Repository

Semua backup disimpan rapi di:

~/Documents/APK_REPOSITORY


Format nama file:

NamaPackage_vVersi.apk

🚀 Cara Install (Sat-set)
🔹 Cara 1 — One-Liner (Paling Cepet)

Tanpa clone repo — langsung jalan:

Ganti URL_GIST_RAW kalau lo pakai script sendiri

bash <(curl -sL https://bit.ly/adb-manager-v4)

🔹 Cara 2 — Manual (Buat yang mau oprek)

Clone repo:

git clone https://github.com/username/adb-apk-manager.git
cd adb-apk-manager


Kasih izin eksekusi:

chmod +x adb_manager.sh


Jalankan:

./adb_manager.sh

🛠️ Prasyarat (Requirements)
🔸 Android Debug Bridge (ADB)

macOS

brew install android-platform-tools


Linux (Arch / CachyOS)

sudo pacman -S android-tools


Linux (Ubuntu / Debian)

sudo apt install adb


Windows

Install ADB & Platform Tools

Pastikan sudah masuk ke PATH

🔸 HP Android

Developer Options ON

USB Debugging ON

Pakai kabel data bagus (biar nggak putus-putus)

📸 Screenshots

(Tempatkan screenshot terminal lo di sini)

Menu Utama

Proses Backup Split APK

⚠️ Disclaimer

Script ini hanya membackup file APK (installer).

Data aplikasi (login, chat, save game, dll.) tidak ikut dibackup — karena batasan Android non-root.

Gunakan dengan bijak — penulis tidak bertanggung jawab atas kehilangan data akibat misuse.

Made with ☕ by AwPetrik
