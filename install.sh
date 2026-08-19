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

        # clipboard, bluetooth, utils
        yay -S blueman nmrs nwg-clipman pavucontrol --noconfirm

        # desktop
        yay -S mangowm-git waybar-git awww swaync swayidle swaylock-effects papirus-icon-theme papirus-folders --noconfirm

        # desktop tools
        yay -S dolphin nomacs rofi matugen waypaper nwg-look calcure kitty neovim fastfetch --noconfirm

        # other dependencies
        yay -S libadwaita qt5ct-kde qt6ct-kde archlinux-xdg-menu wlr-dpms xdg-desktop-portal-kde xdg-desktop-portal-wlr udev-block-notify bibata-cursor-theme ttf-jetbrains-mono-nerd --noconfirm
        ;;
    ""|[Nn]|[Oo])
        clear
        echo "Okay! Assuming you've installed these packages before, onto the next one!"
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
        cp -r ./.local ./.config ./Pictures $HOME
        ;;
    ""|[Nn]|[Oo])
        clear
        echo "All done!"
        echo
        ;;
esac

clear
echo "All done! Thank you for using my dotfiles!"
echo
echo
