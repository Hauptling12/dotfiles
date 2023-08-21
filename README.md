# Packages
- **Window Manager** • [Xmonad](https://xmonad.org/)
- **Shell** • [Zsh](https://www.zsh.org)
- **Panel** • [Xmobar](https://github.com/jaor/xmobar)
- **Terminal** • [st](https://st.suckless.org/)

# Screenshot
![screenshot.png]()

# install
### **arch**
````sh
yay -S vifm socat dunst feh zenity entr ttf-joypixels ttf-bitstream-vera chezmoi fzf urlscan lxsession light
````
### **copy dotfiles**
````sh
chezmoi init https://github.com/hauptling12/dotfiles
chezmoi cd
## Check what changes that chezmoi will make to your home directory by running:
chezmoi diff

## then to copy dotfiles run
chezmoi apply -v
````
