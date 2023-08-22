# use install instructions in README not this
## installation
### base install
#### desktop
install nixos pkg manager
````sh
curl -L https://nixos.org/nix/install | sh
````
arch
```sh
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
~/./.nix-profile/bin/nix-env -iA nixpkgs.drawio
yay -S librewolf-bin zsh zsh-autosuggestions dash zsh-syntax-highlighting bat vifm neofetch unzip unrar gzip shellcheck nasm tldr tree socat zathura mpv qbittorent ffmpegthumbnailer pulsemixer pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber chafa yt-dlp zeal jq zathura-cb zathura-ps zathura-pdf-mupdf zathura-djvu pv buku cmake dunst feh gcc gh sdcv scrcpy keepassxc make zenity pandoc doas onefetch ncdu odt2txt cabextract cpufetch gpufetch-git entr espeak ethtool bandwhich mesa trash-cli ttf-joypixels ttf-bitstream-vera flatpak newsboat calcurse chezmoi lxappearance trayer fzf htop tmux ufw sshfs nmap neovim git base-devel p7zip parallel urlscan sc-im mediainfo lxsession light grip xmonad xmonad-contrib xmobar xorg-server xorg-xinit xautolock xclip arandr redshift xorg-xauth xorg-xinput maim
# if using a laptop
sudo pacman -S tlp tlp-rdw
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```
debian
```sh
./.nix-profile/bin/nix-env -iA nixpkgs.librewolf nixpkgs.onefetch nixpkgs.cpufetch nixpkgs.joypixels nixpkgs.drawio
sudo apt install ffmpegthumbnailer fzf htop tmux pipewire-pulse pipewire-jack wireplumber gzip chafa pipewire curl rsync sshfs neovim nmap git build-essential nala zsh-autosuggestions zsh-syntax-highlighting zsh jq unrar unzip p7zip parallel dunst gh feh mpv pulsemixer shellcheck tldr tree socat qbittorent make pandoc zeal vifm neofetch nasm pv gcc zenity yt-dlp buku cmake bat ncdu odt2txt cabextract entr espeak ethtool gcc keepassxc light zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps mediainfo trayer urlscan scrcpy sdcv sc-im ttf-bitstream-vera doas flatpak newsboat calcurse chezmoi lxappearance ufw dash trash-cli lxsession grip xclip xinput xinit xauth xmonad xmobar xserver-xorg-core xorg arandr redshift xautolock maim
# if using a laptop
sudo apt tlp tlp-rdw
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```
fedora
```sh
# install rpm fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update
sudo dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo

sudo dnf install librewolf
# doas gpufetch-git mesa ttf-bitstream-vera
./.nix-profile/bin/nix-env -iA nixpkgs.librewolf nixpkgs.onefetch nixpkgs.cpufetch nixpkgs.joypixels nixpkgs.drawio nixpkgs.bandwhich
sudo dnf install bat gzip zathura ffmpegthumbnailer pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber chafa zeal zathura-cb zathura-ps zathura-pdf-mupdf zathura-djvu ncdu odt2txt cabextract entr espeak ethtool light zsh-autosuggestions zsh-syntax-highlighting zsh jq unrar unzip p7zip feh gh pulsemixer shellcheck tldr tree socat qbittorent make vifm neofetch nasm pv gcc zenity yt-dlp buku trash-cli fzf htop tmux curl rsync sshfs neovim nmap git parallel mpv qbittorent keepassxc lxsession lxappearance cmake dunst gcc sdcv scrcpy make pandoc dash flatpak newsboat calcurse chezmoi trayer urlscan sc-im mediainfo xmonad xmobar xclip xinput redshift arandr xautolock grip xauth xinit maim

sudo dnf config-manager --add-repo https://rpm.librewolf.net/librewolf-repo.repo

sudo dnf install librewolf
# if using a laptop
sudo dnf install tlp tlp-rdw
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```
#### gaming install
install nixos pkg manager
````sh
curl -L https://nixos.org/nix/install | sh
````
**arch** (make sure that multilib is enabled in `/etc/pacman.conf`)
```sh
git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -S librewolf-bin zsh zsh-autosuggestions dash zsh-syntax-highlighting bat vifm neofetch unzip unrar gzip tldr tree socat mpv qbittorent ffmpegthumbnailer pulsemixer pipewire pipewire-alsa pipewire-audio pipewire-pulse pipewire-jack wireplumber chafa yt-dlp pv cmake dunst feh gcc make zenity doas ncdu cpufetch gpufetch-git mesa trash-cli ttf-joypixels ttf-bitstream-vera flatpak lxappearance trayer fzf htop tmux ufw sshfs nmap neovim git base-devel p7zip parallel mediainfo lxsession light lutris winetricks wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox vulkan-radeon maim gamescope gamemode mangohud
gamemode lib32-vkd3d lib32-vulkan-icd-loader vulkan-tools vkd3d vulkan-tools 
```
suckless
````sh
git clone https://github.com/Hauptling12/st_build
cd st_build
sudo cp st st-copyout st-urlhandler /usr/local/bin
cd .. && git clone https://github.com/Hauptling12/dmenu_build
cd dmenu_build
sudo cp stest dmenu_path dmenu_run dmenu /usr/local/bin
cd .. && git clone https://git.suckless.org/slock
cd slock 
touch config.h
cat config.def.h | sed -e "s/nobody/$USERNAME/g" -e "s/nogroup/$USERNAME/g" > config.h
sudo make install
````

### config
```sh
# disabling tty beeping
echo "blacklist pcspkr" | sudo tee -a /etc/modprobe.d/blacklist.conf
chsh -s /usr/bin/zsh
sudo ln -sfT dash /usr/bin/sh
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
wget https://github.com/B00merang-Project/Windows-10-Dark/archive/refs/tags/3.2.1-dark.tar.gz
tar -vxf 3.2.1-dark.tar.gz
sudo cp 3.2.1-dark /usr/share/themes/
git clone https://github.com/HenriqueLopes42/themeGrub.CyberEXS CyberEXS
git clone https://github.com/yeyushengfan258/Win11-icon-theme
sudo cp -irv Win11-icon-theme/src/ /usr/share/icons/Win11-icon-theme
```
