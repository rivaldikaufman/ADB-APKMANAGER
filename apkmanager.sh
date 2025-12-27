#!/bin/bash

# ==================================================
#  ADB APK MANAGER  (Incremental Repository)
#  Fitur: Smart Skip, Auto Update, Multiplatform
#  By AwPetrik (https://github.com/rivaldikaufman)
# ==================================================

# --- Warna & Style ---
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}       ADB APK MANAGER (By AwPetrik)    ${NC}"
echo -e "${CYAN}   Mac • Linux • Windows (WSL/GitBash)  ${NC}"
echo -e "${CYAN}   (https://github.com/rivaldikaufman)  ${NC}"
echo -e "${CYAN}========================================${NC}"

# --- 1. OS & ADB Detection Logic ---
detect_environment() {
    OS_NAME="$(uname -s)"
    ADB_BIN="adb" # Default command

    case "${OS_NAME}" in
        Linux*)
            if grep -q Microsoft /proc/version 2>/dev/null || grep -q microsoft /proc/version 2>/dev/null; then
                MACHINE="WSL"
                if command -v adb.exe &> /dev/null; then
                    ADB_BIN="adb.exe"
                fi
            else
                MACHINE="Linux"
            fi
            ;;
        Darwin*)    MACHINE="macOS";;
        CYGWIN*|MINGW*|MSYS*) MACHINE="Windows (GitBash)";;
        *)          MACHINE="Unknown: ${OS_NAME}";;
    esac

    echo -e "${GREEN}💻 Detected OS: $MACHINE${NC}"
    echo -e "${GREEN}🔧 Using ADB Binary: $ADB_BIN${NC}"
}

check_adb_installed() {
    if ! command -v "$ADB_BIN" &> /dev/null; then
        echo -e "\n${RED}❌ FATAL ERROR: ADB gak ketemu!${NC}"
        echo "Solusi buat $MACHINE:"
        case "$MACHINE" in
            "macOS") echo "   👉 Run: brew install android-platform-tools" ;;
            "Linux") echo "   👉 Run: sudo pacman -S android-tools" ;;
            "WSL")   echo "   👉 Pastikan 'adb.exe' terinstall di Windows path." ;;
            *)       echo "   👉 Install Android Platform Tools." ;;
        esac
        exit 1
    fi
}

detect_environment
check_adb_installed

# --- Konfigurasi Path (REPOSITORY MODE) ---
# Kita pakai satu folder pusat, bukan per tanggal, untuk support incremental.
BACKUP_REPO="$HOME/Documents/APK_REPOSITORY"

# --- 2. Cek Device ---
check_device() {
    echo -e "${YELLOW}🔍 Checking device via $ADB_BIN...${NC}"
    local device_raw=$($ADB_BIN devices | grep -v "List" | grep "device")

    if [ -z "$device_raw" ]; then
        echo -e "${RED}❌ HP gak kedeteksi!${NC}"
        echo "Tips: Cek kabel USB atau nyalain USB Debugging."
        exit 1
    else
        local model=$($ADB_BIN shell getprop ro.product.model | tr -d '\r')
        local serial=$(echo $device_raw | awk '{print $1}')
        echo -e "${GREEN}✅ Connected: $BOLD$model$NC ($serial)"
    fi
}

# --- 3. Fungsi Backup (Incremental Logic) ---
do_backup() {
    mkdir -p "$BACKUP_REPO"
    echo -e "${CYAN}📂 Repository: $BACKUP_REPO${NC}"

    echo -e "${YELLOW}⏳ Scanning apps di HP...${NC}"

    # Sanitasi list package
    raw_packages=$($ADB_BIN shell pm list packages -3 | sed 's/package://g' | tr -d '\r')

    if [ -z "$raw_packages" ]; then
        echo -e "${RED}🤔 Tidak ada aplikasi 3rd party.${NC}"
        return
    fi

    IFS=$'\n' read -rd '' -a package_array <<< "$raw_packages"
    total=${#package_array[@]}

    echo -e "${CYAN}🔍 Ditemukan $total aplikasi. Cek perubahan data...${NC}"

    count=0
    success=0
    skipped=0
    fail=0

    for app in "${package_array[@]}"; do
        ((count++))
        app=$(echo "$app" | xargs)
        if [ -z "$app" ]; then continue; fi

        # Ambil Versi (Kunci Incremental)
        version=$($ADB_BIN shell dumpsys package $app | grep -m1 "versionName" | cut -d= -f2 | tr -d '\r' | sed 's/ /_/g')
        [ -z "$version" ] && version="unknown"

        # Cek Split
        paths=$($ADB_BIN shell pm path "$app" | cut -f 2 -d ":")
        path_count=$(echo "$paths" | wc -l)

        # Progress display (Compact)
        echo -ne "\r[$count/$total] Checking $app (v$version)... "

        if [ "$path_count" -gt 1 ]; then
            # --- SPLIT APK LOGIC ---
            target_dir="$BACKUP_REPO/${app}_v${version}_SPLIT"

            # [MITIGASI DOUBLE DATA]
            if [ -d "$target_dir" ]; then
                # Cek isinya kosong gak? Kalau ada isinya, anggap skip.
                if [ "$(ls -A "$target_dir")" ]; then
                    # Clear line, print skip
                    echo -e "\r\033[K${PURPLE}⏭️  [SKIP] $app v$version (Sudah ada)${NC}"
                    ((skipped++))
                    continue
                fi
            fi

            # Kalau belum ada, buat & pull
            mkdir -p "$target_dir"
            split_success=true

            echo -e "\n   ⬇️  Downloading Split APK..."
            while IFS= read -r p; do
                clean_path=$(echo "$p" | tr -d '\r')
                filename=$(basename "$clean_path")
                if ! $ADB_BIN pull "$clean_path" "$target_dir/$filename" > /dev/null 2>&1; then
                    split_success=false
                fi
            done <<< "$paths"

            if [ "$split_success" = true ]; then
                echo -e "   ${GREEN}✅ Success${NC}"
                ((success++))
            else
                echo -e "   ${RED}❌ Failed${NC}"
                ((fail++))
            fi

        else
            # --- SINGLE APK LOGIC ---
            target_file="$BACKUP_REPO/${app}_v${version}.apk"
            clean_path=$(echo "$paths" | tr -d '\r')

            # [MITIGASI DOUBLE DATA]
            if [ -f "$target_file" ]; then
                echo -e "\r\033[K${PURPLE}⏭️  [SKIP] $app v$version (Sudah ada)${NC}"
                ((skipped++))
                continue
            fi

            if [ -n "$clean_path" ]; then
                echo -ne "\n   ⬇️  Downloading..."
                if $ADB_BIN pull "$clean_path" "$target_file" > /dev/null 2>&1; then
                    echo -e "${GREEN} ✅ OK${NC}"
                    ((success++))
                else
                    echo -e "${RED} ❌ Fail${NC}"
                    ((fail++))
                fi
            else
                 echo -e "${RED} ❌ Not Found${NC}"
                 ((fail++))
            fi
        fi
    done

    echo -e "\n${BOLD}📊 LAPORAN SINKRONISASI:${NC}"
    echo -e "   ✅ Baru/Update: $success"
    echo -e "   ⏭️ Di-skip:     $skipped"
    echo -e "   ❌ Gagal:       $fail"
    echo -e "   📂 Repository:  $BACKUP_REPO"

    if [[ "$MACHINE" == "Linux" ]]; then xdg-open "$BACKUP_REPO" 2>/dev/null; fi
    if [[ "$MACHINE" == "macOS" ]]; then open "$BACKUP_REPO"; fi
}

# --- 4. Fungsi Restore ---
do_restore() {
    # Karena sekarang repo, kita kasih pilihan mau restore dari mana
    echo -e "${YELLOW}📂 Pilih Mode Restore:${NC}"
    echo "1) Restore SEMUA dari Repository Utama"
    echo "2) Pilih Folder Backup Manual (Kustom)"
    read -p "Pilih: " rest_opt

    TARGET_DIR=""

    if [ "$rest_opt" == "1" ]; then
        TARGET_DIR="$BACKUP_REPO"
    else
        echo -e "\n${BOLD}Paste path atau Drag folder backup:${NC}"
        read -r TARGET_DIR
        TARGET_DIR="${TARGET_DIR%/}"
        TARGET_DIR=$(echo "$TARGET_DIR" | tr -d "'\"")
    fi

    if [ ! -d "$TARGET_DIR" ]; then
        echo -e "${RED}❌ Folder tidak valid!${NC}"
        return
    fi

    cd "$TARGET_DIR" || exit
    echo -e "${CYAN}📦 Restore dimulai dari: $TARGET_DIR${NC}"
    echo -e "${RED}⚠️  Note: Proses ini akan mencoba install semua APK di folder.${NC}"
    echo -e "${RED}    Kalau ada v1 dan v2, keduanya akan dicoba install.${NC}"
    read -p "Lanjut? (y/n) " confirm
    if [[ $confirm != "y" ]]; then return; fi

    # Restore Single
    shopt -s nullglob
    for apk in *.apk; do
        echo -e "📥 Installing: ${CYAN}$apk${NC}..."
        $ADB_BIN install -r "$apk"
    done

    # Restore Split
    for dir in *_SPLIT; do
        if [ -d "$dir" ]; then
            echo -e "📥 Installing Split: ${YELLOW}$dir${NC}..."
            cmd_args=("install-multiple" "-r")
            files=("$dir"/*.apk)
            if [ ${#files[@]} -gt 0 ]; then
                for f in "${files[@]}"; do
                    cmd_args+=("$f")
                done
                "$ADB_BIN" "${cmd_args[@]}"
            fi
        fi
    done
    shopt -u nullglob
    echo -e "${GREEN}✅ Restore Selesai!${NC}"
}

# --- Main Menu ---
check_device
while true; do
    echo -e "\n${CYAN}--- SELECT MENU ---${NC}"
    echo "1) 🔄 Sync/Backup Apps"
    echo "2) 📥 Restore Apps"
    echo "3) 🚪 Keluar"
    read -p "Pilih: " opt
    case $opt in
        1) do_backup ;;
        2) do_restore ;;
        3) exit 0 ;;
        *) echo "Salah woy." ;;
    esac
done
