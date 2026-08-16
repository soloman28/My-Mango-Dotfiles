#!/bin/sh

clear
printf "Howdy! This requires yay to be installed in password.
Do you wish to accept this and install the rest?
Exercise your safety first.

[Y/n]

"
if ! read -r -t 30 answer; then
    answer="y"
    answer="n"
    printf '\n'
fi

case "$answer" in
    ""|[Yy]|[Yy][Ee][Ss])
        sudo pacman -S --needed git base-devel --noconfirm
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf go yay

        # Syu
        yay -Syu qt5ct-kde qt6ct-kde calcure papirus-folders udev-block-notify wlr-dpms mangowm-git waybar-git nmtui-go --noconfirm

        # clipboard, bluetooth, utils
        yay -S blueman, nmtui, nwg-clipman pavucontrol --noconfirm

        # desktop
        yay -S awww swaync swayidle swaylock-effects papirus-icon-theme --noconfirm

        # desktop tools
        yay -S matugen waypaper nwg-look kitty neovim fastfetch --noconfirm

        # other depenndencies
        yay -S libadwaita archlinux-xdg-menu wlr-dpms xdg-desktop-portal-wlr --noconfirm
        ;;
    ""|[Nn]|[Oo])
        clear
        echo "Okay! Onto the next one!"
        sleep 2
        ;;
esac

clear
printf "Do you wish to copy my dotfiles config into your user directory?

[Y/n]

"
if ! read -r -t 30 answer; then
    answer="y"
    answer="n"
    printf '\n'
fi

case "$answer" in
    ""|[Yy]|[Yy][Ee][Ss])
        cd
        cd My-Mango-Dotfiles
        cp -r ./.local ./.config $HOME
        ;;
    ""|[Nn]|[Oo])
        clear
        echo "All done!"
        echo
        ;;
esac

clear
printf "All done! Thank you for using my dotfiles!"
