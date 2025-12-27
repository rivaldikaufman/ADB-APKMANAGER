# 📱 ADB APK Manager

![bash](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)
![adb](https://img.shields.io/badge/Android-ADB-3DDC84?logo=android&logoColor=white)
![linux](https://img.shields.io/badge/Linux-Supported-FCC624?logo=linux&logoColor=black)
![macos](https://img.shields.io/badge/macOS-Supported-000000?logo=apple&logoColor=white)
![wsl](https://img.shields.io/badge/WSL-Compatible-0078D4?logo=windows&logoColor=white)
![license](https://img.shields.io/badge/License-MIT-blue)

<p align="center">
  <img src="https://github.com/user-attachments/assets/1ca6ff97-5b3e-450e-9d59-0fe0f5a937b2" alt="Screenshot ADB Manager">
</p>

ADB APK Manager cocok buat kamu yang sering gonta-ganti Custom ROM tapi nggak mau repot install ulang aplikasi satu per satu. Tool ini berupa script Bash yang sederhana namun cukup powerful untuk melakukan backup dan restore aplikasi Android. Termasuk yang berbasis Split APK / App Bundles lewat ADB secara batch, cepat, dan gak ribet.

---

## 🌍 Kompatibilitas
- 🐧 **Linux** (Arch / Debian)
- 🍎 **macOS** (Intel & Apple Silicon)
- 🪟 **Windows** via **WSL / Git Bash**

---

## 🔥 Fitur Andalan

### 📦 Split APK Support 
✔ Deteksi otomatis aplikasi App Bundle (Instagram, Shopee, Gojek, dll.)  
✔ Backup semua pecahan APK (base, config, dll) ke folder khusus  
✔ Restore pakai `adb install-multiple` → **jalan normal, tanpa FC**

### 🖥️ Multi-Platform + WSL Bridge
- Jalan native di **macOS & Linux**
- **WSL Smart Detection** → otomatis pakai `adb.exe` milik Windows  
  ➜ **tanpa ribet setup usbipd**

### ⚡ Incremental Backup (Smart Skip)
⏱ Hemat waktu & kuota:

- Jika versi di HP **sama** → **SKIP**
- Jika versi beda → otomatis backup versi terbaru

## 🗂️ Lokasi Backup
```~/Documents/APK_REPOSITORY```


### Format nama file:
NamaPackage_vVersi.apk

## 🚀 Cara Install
### 🔹 Cara 1 — One-Liner (paling cepat)
```curl -sSL bit.ly/adbapkmanager | bash```

### 🔹 Cara 2 — Manual
```bash
git clone https://github.com/rivaldikaufman/ADB-APKMANAGER.git
cd ADB-APKMANAGER
chmod +x apkmanager.sh
./apkmanager.sh
```

## 🛠️ Prasyarat
### 📦 ADB
#### macOS
```brew install android-platform-tools```

#### Arch / CachyOS
```sudo pacman -S android-tools```

#### Ubuntu / Debian
```sudo apt install adb```

#### Windows: 
```install Android Platform Tools lalu tambahkan ke PATH.```

## 📱 Android Device

Developer Options ON

USB Debugging ON

Gunakan kabel data yang bagus (lebih stabil)


## ⚠️ Disclaimer

Script hanya membackup APK (installer).
**Data aplikasi (login, chat, save game, dll.) TIDAK IKUT DI BACKUP (non-root).**

Gunakan dengan bijak. Risiko ditanggung pengguna.

Made with ☕ by AwPetrik
---


---

