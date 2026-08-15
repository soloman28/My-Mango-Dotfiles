#!/usr/bin/env bash

clear

if [[ $EUID -ne 0 ]]; then
    echo "Root is needed to install dependencies. Please run as superuser."
    exit 1
fi

if [[ -z "$SUDO_USER" || "$SUDO_USER" == "root" ]]; then
    echo "Please run this script with sudo."
    exit 1
fi

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

if [[ -z "$USER_HOME" || ! -d "$USER_HOME" ]]; then
    echo "Could not determine the user's home directory."
    exit 1
fi

selectedPackageManager=""

yay=false
paru=false

echoLogo() {
    echo "======================================="
    echo "===========| My Mango Dots |==========="
    echo "======================================="
}

getPackageManager() {
    clear
    echoLogo
    echo
    echo "Both Yay and Paru are installed."
    echo "Which one should be used?"
    echo
    echo "[y] Yay"
    echo "[p] Paru"
    echo

    read -r packageManager

    case "$packageManager" in
        y|yay|Y|YAY)
            selectedPackageManager="yay"
            yayInstallPackages
            ;;
        p|paru|P|PARU)
            selectedPackageManager="paru"
            paruInstallPackages
            ;;
        *)
            echo
            echo "Wrong input."
            sleep 1
            getPackageManager
            ;;
    esac
}

installPackageManagerParu() {
    clear
    echoLogo
    echo
    echo "Installing Paru..."
    echo

    pacman -S --needed --noconfirm git base-devel

    if [[ ! -d "$USER_HOME/paru" ]]; then
        sudo -u "$SUDO_USER" git clone https://aur.archlinux.org/paru.git "$USER_HOME/paru"
    fi

    cd "$USER_HOME/paru" || exit 1

    sudo -u "$SUDO_USER" makepkg -si --noconfirm

    cd "$USER_HOME" || exit 1
    rm -rf "$USER_HOME/paru"

    clear
    echoLogo
}

installPackageManagerYay() {
    clear
    echoLogo
    echo
    echo "Installing Yay..."
    echo

    pacman -S --needed --noconfirm git base-devel

    if [[ ! -d "$USER_HOME/yay-bin" ]]; then
        sudo -u "$SUDO_USER" git clone https://aur.archlinux.org/yay-bin.git "$USER_HOME/yay-bin"
    fi

    cd "$USER_HOME/yay-bin" || exit 1

    sudo -u "$SUDO_USER" makepkg -si --noconfirm

    cd "$USER_HOME" || exit 1
    rm -rf "$USER_HOME/yay-bin"

    clear
    echoLogo
}

installPackageManagerCheck() {
    clear
    echoLogo
    echo
    echo "Could not find Yay or Paru."
    echo "Do you want to install one?"
    echo
    echo "[y] Yay"
    echo "[p] Paru"
    echo "[n] No"
    echo

    read -r installPackageManager

    case "$installPackageManager" in
        y|yay|Y|YAY)
            installPackageManagerYay
            yayInstallPackages
            ;;
        p|paru|P|PARU)
            installPackageManagerParu
            paruInstallPackages
            ;;
        n|no|N|NO|No)
            clear
            echoLogo
            echo
            echo "Not installing a package manager."
            echo "A package manager is required. Exiting..."
            exit 1
            ;;
        *)
            echo
            echo "Wrong input."
            sleep 1
            installPackageManagerCheck
            ;;
    esac
}

yayInstallPackages() {
    clear
    echoLogo
    echo
    echo "Installing packages with Yay..."
    echo

    sudo -u "$SUDO_USER" yay -Sy --noconfirm \
        qt5ct-kde \
        qt6ct-kde \
        calcure \
        papirus-folders \
        udev-block-notify \
        wlr-dpms \
        mangowm-git \
        nmtui-go \
        waybar-git \

    yay -S --noconfirm \
        kitty \
        matugen \
        libadwaita \
        papirus-icon-theme \
        swaylock-effects \
        swayidle \
        swaync \
        awww \
        pavucontrol \
        blueman \
        rofi \
        neovim \
        fastfetch \
        archlinux-xdg-menu \
        xdg-desktop-portal-wlr \
        waypaper \
        nwg-look \
        nwg-clipman \
        --overwrite "*"

    if [[ $? -ne 0 ]]; then
        echo
        echo "Package installation failed."
        exit 1
    fi

    clear
    echoLogo
}

paruInstallPackages() {
    clear
    echoLogo
    echo
    echo "Installing packages with Paru..."
    echo

    sudo -u "$SUDO_USER" paru -Sy --noconfirm \
        qt5ct-kde \
        qt6ct-kde \
        calcure \
        papirus-folders \
        udev-block-notify \
        wlr-dpms \
        mangowm-git \
        nmtui-go \
        waybar-git \

    paru -S --noconfirm \
        kitty \
        matugen \
        libadwaita \
        papirus-icon-theme \
        swaylock-effects \
        swayidle \
        swaync \
        awww \
        pavucontrol \
        blueman \
        rofi \
        neovim \
        fastfetch \
        archlinux-xdg-menu \
        xdg-desktop-portal-wlr \
        waypaper \
        nwg-look \
        nwg-clipman \
        --overwrite "*"

    if [[ $? -ne 0 ]]; then
        echo
        echo "Package installation failed."
        exit 1
    fi

    clear
    echoLogo
}

createDotfiles() {
    cd My-Mango-Dotfiles
    -exec cp -a ./.local/ ./.config / \;
}

askDotfiles() {
    clear
    echoLogo
    echo
    echo "Copy the contents from the dotfiles?"
    echo
    echo "[y] Yes"
    echo "[n] No"
    echo

    read -r dotfileChoice

    case "$dotfileChoice" in
        y|Y|yes|YES|Yes)
            createDotfiles
            echo
            echo "Creating dotfiles done."
            ;;
        n|N|no|NO|No)
            echo
            echo "No dotfiles created."
            ;;
        *)
            echo
            echo "Wrong input."
            sleep 1
            askDotfiles
            ;;
    esac
}

createBackup() {
    local backupDir="$USER_HOME/.config/backup"

    mkdir -p "$backupDir"

    find "$USER_HOME/.config" \
        -mindepth 1 \
        -maxdepth 1 \
        ! -name backup \
        -exec cp -r {} "$backupDir/" \;

    chown -R "$SUDO_USER:$SUDO_USER" "$backupDir"
}

askBackup() {
    clear
    echoLogo
    echo
    echo "Create a backup of .config?"
    echo
    echo "[y] Yes"
    echo "[n] No"
    echo

    read -r backupChoice

    case "$backupChoice" in
        y|Y|yes|YES|Yes)
            createBackup
            echo
            echo "Backup done."
            ;;
        n|N|no|NO|No)
            echo
            echo "No backup created."
            ;;
        *)
            echo
            echo "Wrong input."
            sleep 1
            askBackup
            ;;
    esac
}

if command -v yay > /dev/null 2>&1; then
    yay=true
fi

if command -v paru > /dev/null 2>&1; then
    paru=true
fi

echoLogo

if [[ $yay == true && $paru == true ]]; then
    getPackageManager
elif [[ $yay == true ]]; then
    yayInstallPackages
elif [[ $paru == true ]]; then
    paruInstallPackages
else
    installPackageManagerCheck
fi

askDotfiles
askBackup

clear
echoLogo
echo
echo "All done."
echo
exit 0
