#!/usr/bin/env bash

clear

if [[ "$EUID" -ne 0 ]]; then
    echo "Uh uh uh! You need to run as a root!"
    exit
fi

if [[ -z "$SUDO_USER" || "$SUDO_USER" == "root" ]]; then
    echo "Uh uh uh! You have to run this script with sudo!"
    exit
fi

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

if [[ -z "$USER_HOME" || ! -d "$USER_HOME" ]]; then
    echo "Whoops! This could not determine the user's home directory, could it?"
    exit
fi

packageManager=""

yay=false

echoIntro () {
    echo "Howdy! Some of these packages require yay or manual install."
    echo "If you're okay with it, would you like to install it?"
    echo "This requires an internet connection."
}

packageManagerCheck() {
    clear
    echoIntro
    echo
    echo "[Y] Yes!"
    echo "[N] No!"

    read -r installPackageManager

    case "$installPackageManager" in
        y|yes|Y|YES)
            installPackageManager
        ;;
        n|no|N|NO)
            clear
            echo "Alright, better luck next time!"
            exit
            ;;
        *)
            echo
            echo "Oops! Wrong input!"
            sleep 1
            getPackageManager
            ;;
    esac
}

getPackageManager() {
    clear
    echo "Looks like Yay is installed!"
    echo "Are you sure you're going to install packages?"
    echo
    echo "[Y] Yes!"
    echo "[N] No!"

    read -r packageManager

    case "$packageManager" in
        y|yes|Y|YES)
            installPackages
        ;;
        n|no|N|NO)
            clear
            echo "Alright, better luck next time!"
            exit
            ;;
        *)
            echo
            echo "Oops! Wrong input!"
            sleep 1
            getPackageManager
            ;;
    esac
}


installPackageManager() {
    clear
    echo "Yay going up!"
    echo

    pacman -Syu --needed --noconfirm git base-devel

    if [[ ! -d "$USER_HOME/yay-bin" ]]; then
        sudo -u "$SUDO_USER" git clone https://aur.archlinux.org/yay-bin.git "$USER_HOME/yay-bin"
    fi

    cd "$USER_HOME/yay-bin" || exit 1

    sudo -u "$SUDO_USER" makepkg -si --noconfirm

    cd "$USER_HOME" || exit 1
    rm -rf "$USER_HOME/yay-bin"

    clear
}

installPackages() {
    clear
    echo "Installing packages with Yay going up!"
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
        echo "Whoops, package installation failed!"
        exit
    fi

    clear
}

createDotfiles() {
    cp -a ./.local/ ./.config / \;
}

askDotfiles() {
    clear
    echo "Almost done! Do you want to copy the dotfiles?"
    echo
    echo "[y] Yes"
    echo "[n] No"
    echo

    read -r dotfileChoice

    case "$dotfileChoice" in
        y|Y|yes|YES|Yes)
            createDotfiles
            echo
            echo "It's done!"
            ;;
        n|N|no|NO|No)
            echo
            echo "No dotfiles created..."
            ;;
        *)
            echo
            echo "Oops! Wrong input!"
            sleep 1
            askDotfiles
            ;;
    esac
}

if command -v yay > /dev/null 2>&1; then
    yay=true
fi

if [[ $yay == true ]]; then
    getPackageManager
elif [[ $yay == true ]]; then
    installPackages
else
    packageManagerCheck
fi

askDotfiles

clear
echo "All done! Thank you for using my dotfiles!"
echo
exit 0