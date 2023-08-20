#!/bin/bash
os_name=$(cat /etc/os-release|sed -n 1p | grep -oP '(?<=").*(?=")')
in_type=$(echo "server\ndesktop\ngaming" |fzf)
ds_type=$(echo "none\nxorg (xmonad)\nwayland (hypr)" |fzf |awk '{print $1}')
# disabling tty beeping
sudo touch /etc/modprobe.d/blacklist.conf
echo "blacklist pcspkr" | sudo tee -a /etc/modprobe.d/blacklist.conf
if [[ $os_name == "Arch Linux" ]]; then
    # updating and installing core pkgs
    sudo pacman -Syu --noconfirm
    sudo pacman -S fzf htop tmux ufw sshfs nmap neovim git base-devel p7zip parallel --noconfirm
    if [[ $in_type == "desktop" ]];then
        cd "$HOME" || exit
        mkdir build && cd build || exit
        git clone https://github.com/Hauptling12/dotfiles
        git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
        cd "$HOME" || exit
        sudo yay -S librewolf-bin
        echo_info "installing $ds_type"
        if [[ $ds_type == "xorg" ]];then
            sudo pacman -S xmonad xmonad-contrib xmobar xorg-server xinit xautolock xclip arandr redshift
            cd "$HOME"/build || exit
            git clone https://github.com/Hauptling12/st_build
            cd st_build || exit
            sudo cp st st-copyout st-urlhandler /usr/local/bin
            cd  $HOME/build || exit
            git clone https://github.com/Hauptling12/dmenu_build
            cd dmenu_build || exit
            sudo cp stest dmenu_path dmenu_run dmenu /usr/local/bin
            cd "$HOME"/build || exit
            git clone https://git.suckless.org/slock
            cd slock || exit
            touch config.h
            cat config.def.h | sed -e "s/nobody/$USERNAME/g" -e "s/nogroup/$USERNAME/g" > config.h
            sudo make install
        fi


        elif [[ $ds_type == "wayland" ]]; then
            yay -S hyprland-git eww-wayland xdg-desktop-portal-hyprland-git wezterm wev
        fi
        sudo yay -S zsh zsh-autosuggestions dash zsh-syntax-highlighting bat vifm neofetch unzip unrar gzip shellcheck nasm tldr tree socat zathura mpv qbittorent ffmpegthumbnailer pulsemixer pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber chafa yt-dlp zeal jq zathura-cb zathura-ps zathura-pdf-mupdf zathura-djvu pv buku cmake dunst feh gcc gh sdcv scrcpy keepassxc make zenity pandoc doas onefetch ncdu odt2txt cabextract cpufetch gpufetch-git entr espeak ethtool bandwhich mesa gnome-keyring trash-cli ttf-joypixels ttf-bitstream-vera flatpak newsboat calcurse chezmoi lxappearance trayer
        cd "$HOME" && mkdir .local .config
        if [[ $(echo "using laptop\nnot using laptop" | fzf) == "not using laptop" ]]; then
            sudo pacman -S tlp tlp-rdw
            cd "$HOME"/build/ || exit
            git clone https://github.com/AdnanHodzic/auto-cpufreq.git
            cd auto-cpufreq && sudo ./auto-cpufreq-installer
            cd "$HOME" || exit
        fi
        chsh -s /usr/bin/zsh
        sudo ln -sfT dash /usr/bin/sh
        curl -L https://nixos.org/nix/install | sh
        ~/./.nix-profile/bin/nix-env -iA nixpkgs.drawio
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        cd "$HOME"/build || exit
        wget https://github.com/B00merang-Project/Windows-10-Dark/archive/refs/tags/3.2.1-dark.tar.gz
        tar -vxf 3.2.1-dark.tar.gz
        mkdir $HOME/.local/share/themes
        cp 3.2.1-dark $HOME/.local/share/themes
        git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS CyberEXS

    fi

    if [[ $in_type == "gaming" ]]; then
        cd "$HOME" || exit
        mkdir build && cd build || exit
        git clone https://github.com/Hauptling12/dotfiles
        git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
        cd "$HOME" || exit
        sudo yay -S librewolf-bin
        if [[ $ds_type == "xorg" ]];then
            sudo pacman -S xmonad xmonad-contrib xmobar xorg-server xinit xautolock xclip arandr redshift
            cd "$HOME"/build || exit
            git clone https://github.com/Hauptling12/st_build
            cd st_build || exit
            sudo cp st st-copyout st-urlhandler /usr/local/bin
            cd  $HOME/build || exit
            git clone https://github.com/Hauptling12/dmenu_build
            cd dmenu_build || exit
            sudo cp stest dmenu_path dmenu_run dmenu /usr/local/bin
            cd "$HOME"/build || exit
            git clone https://git.suckless.org/slock
            cd slock || exit
            touch config.h
            cat config.def.h | sed -e "s/nobody/$USERNAME/g" -e "s/nogroup/$USERNAME/g" > config.h
            sudo make install
        fi


        elif [[ $ds_type == "wayland" ]]; then
            yay -S hyprland-git eww-wayland xdg-desktop-portal-hyprland-git wezterm wev
        fi
        sudo yay zsh zsh-autosuggestions dash zsh-syntax-highlighting bat vifm neofetch unzip unrar gzip mpv qbittorent ffmpegthumbnailer pulsemixer pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber yt-dlp cmake dunst feh gcc ncdu cpufetch gpufetch nvtop mesa gnome-keyring trash-cli ttf-joypixels ttf-bitstream-vera trash-cli obs-studio lutris mangohud winetricks trayer flatpak lxappearance
        chsh -s /usr/bin/zsh
        sudo ln -sfT dash /usr/bin/sh
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        cd "$HOME"/build || exit
        wget https://github.com/B00merang-Project/Windows-10-Dark/archive/refs/tags/3.2.1-dark.tar.gz
        tar -vxf 3.2.1-dark.tar.gz
        mkdir $HOME/.local/share/themes
        cp 3.2.1-dark $HOME/.local/share/themes
        git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS CyberEXS
    fi
fi

elif [[ $os_name == "Fedora" ]]; then
    sudo dnf update
    sudo dnf install fzf htop tmux curl rsync sshfs neovim nmap git parallel
    if [[ $in_type == "desktop" ]];then
        sudo dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo
        sudo dnf install librewolf
        cd "$HOME" && mkdir build && cd build
        git clone https://github.com/Hauptling12/dotfiles
        if [[ $ds_type == "xorg" ]];then
            sudo dnf install xmonad xmobar xclip xinput
            cd "$HOME"/build
            git clone https://github.com/Hauptling12/st_build
            cd st_build
            sudo cp st st-copyout st-urlhandler /usr/local/bin
            cd  $HOME/build
            git clone https://github.com/Hauptling12/dmenu_build
            cd dmenu_build
            sudo cp stest dmenu_path dmenu_run dmenu /usr/local/bin
            cd "$HOME"/build
            git clone https://git.suckless.org/slock
            cd slock
            touch config.h
            cat config.def.h | sed -e "s/nobody/$USERNAME/g" -e "s/nogroup/$USERNAME/g" > config.h
            sudo make install

        sudo dnf install ncdu odt2txt cabextract entr espeak ethtool light zsh-autosuggestions zsh-syntax-highlighting zsh jq unrar unzip p7zip feh gh pulsemixer shellcheck tldr tree socat qbittorent make vifm neofetch nasm pv gcc zenity yt-dlp buku trash-cli
        sudo dnf copr enable atim/bandwhich -y && sudo dnf install bandwhich
        chsh -s /usr/bin/zsh
        sudo ln -sfT dash /usr/bin/sh


elif [[ $os_name == "Debian GNU/Linux" ]]; then
    sudo apt update && upgrade
    sudo apt install fzf htop tmux curl rsync sshfs neovim nmap git build-essential
    if [[ $in_type == "desktop" ]];then
        curl -L https://nixos.org/nix/install | sh
        cd "$HOME" && ./.nix-profile/bin/nix-env -iA nixpkgs.librewolf
        mkdir $HOME/build && cd build
        git clone https://github.com/Hauptling12/dotfiles
        if [[ $ds_type == "xorg" ]]; then
            sudo apt install xclip xinput xinit xauth xmonad xmobar xserver-xorg-core xorg arandr redshift
            cd "$HOME"/build
            git clone https://github.com/Hauptling12/st_build
            cd st_build
            sudo cp st st-copyout st-urlhandler /usr/local/bin
            cd  $HOME/build
            git clone https://github.com/Hauptling12/dmenu_build
            cd dmenu_build
            sudo cp stest dmenu_path dmenu_run dmenu /usr/local/bin
            cd "$HOME"/build
            git clone https://git.suckless.org/slock
            cd slock
            touch config.h
            cat config.def.h | sed -e "s/nobody/$USERNAME/g" -e "s/nogroup/$USERNAME/g" > config.h
            sudo make install
            cd "$HOME"/build/dotfiles/private_dot_config/
            cp xmonad xmobar ../executable_dot_xinitrc x11
        fi
        sudo apt install nala zsh-autosuggestions zsh-syntax-highlighting zsh jq unrar unzip p7zip parallel dunst gh feh mpv pulsemixer shellcheck tldr tree socat qbittorent make pandoc zeal vifm neofetch nasm pv gcc zenity yt-dlp buku cmake bat ncdu odt2txt cabextract entr espeak ethtool gcc keepassxc light zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps mediainfo trayer urlscan scrcpy sdcv sc-im ttf-bitstream-vera
        chsh -s /usr/bin/zsh
        sudo ln -sfT dash /usr/bin/sh
    fi
else
    echo "Distro not supported"
fi
