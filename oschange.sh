#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║   TyranRoot OS — Termux Customization Tool v1.1             ║
# ║   Fixed for Termux Compatibility                            ║
# ╚══════════════════════════════════════════════════════════════╝

# ── Colors ────────────────────────────────────────────────────
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'
B='\033[1;34m'; M='\033[1;35m'; C='\033[1;36m'
W='\033[1;37m'; DIM='\033[2m';  RS='\033[0m'

# ── Terminal Width (Fixed for Termux) ──────────────────────
TW=60  # Fixed width for Termux
BW=56
PAD=$(( (TW - BW) / 2 ))
LP=$(printf '%*s' "$PAD" "")

# ── Config File ───────────────────────────────────────────────
CONFIG="$HOME/.tyranroot_config"
if [ ! -f "$CONFIG" ]; then
    cat > "$CONFIG" <<'CONF'
USERNAME=TyranRoot
HOSTNAME=TyranRoot
SHELL_COLOR=cyan
PROMPT_STYLE=kali
BANNER_STYLE=1
CONF
fi

source "$CONFIG" 2>/dev/null

# ── Helper Functions ──────────────────────────────────────────
clr_code() {
    case "$1" in
        red)     echo '\033[1;31m' ;;
        green)   echo '\033[1;32m' ;;
        yellow)  echo '\033[1;33m' ;;
        blue)    echo '\033[1;34m' ;;
        magenta) echo '\033[1;35m' ;;
        cyan)    echo '\033[1;36m' ;;
        white)   echo '\033[1;37m' ;;
        *)       echo '\033[1;36m' ;;
    esac
}

cline() {
    printf "${C}${LP}%s" "$1"
    for ((i=0; i<BW-2; i++)); do printf "═"; done
    printf "%s${RS}\n" "$2"
}

cmid() {
    local text="$1" color="${2:-$W}"
    local len=${#text}
    local sp=$(( (BW - 2 - len) / 2 ))
    local sp2=$(( BW - 2 - len - sp ))
    [ $sp -lt 0 ] && sp=0
    [ $sp2 -lt 0 ] && sp2=0
    printf "${C}${LP}║%*s${color}%s${C}%*s║${RS}\n" "$sp" "" "$text" "$sp2" ""
}

cempty() { printf "${C}${LP}║%*s║${RS}\n" $((BW-2)) ""; }

press_enter() {
    echo -e "\n${LP}${DIM}Press Enter to continue...${RS}"
    read -r
}

# ── BANNER ───────────────────────────────────────────────────
banner() {
    clear
    echo -e ""

    if [ "$BANNER_STYLE" = "1" ]; then
        echo -e "${C}${LP}  ████████╗██╗   ██╗██████╗  █████╗ ███╗   ██╗${RS}"
        echo -e "${C}${LP}     ██╔══╝╚██╗ ██╔╝██╔══██╗██╔══██╗████╗  ██║${RS}"
        echo -e "${G}${LP}     ██║    ╚████╔╝ ██████╔╝███████║██╔██╗ ██║${RS}"
        echo -e "${G}${LP}     ██║     ╚██╔╝  ██╔══██╗██╔══██║██║╚██╗██║${RS}"
        echo -e "${R}${LP}     ██║      ██║   ██║  ██║██║  ██║██║ ╚████║${RS}"
        echo -e "${R}${LP}     ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝${RS}"
        echo -e "${DIM}${LP}           ██████╗  ██████╗  ██████╗ ████████╗${RS}"
        echo -e "${DIM}${LP}           ██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝${RS}"
        echo -e "${C}${LP}           ██████╔╝██║   ██║██║   ██║   ██║   ${RS}"
        echo -e "${C}${LP}           ██╔══██╗██║   ██║██║   ██║   ██║   ${RS}"
        echo -e "${G}${LP}           ██║  ██║╚██████╔╝╚██████╔╝   ██║   ${RS}"
        echo -e "${G}${LP}           ╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝   ${RS}"
    elif [ "$BANNER_STYLE" = "2" ]; then
        echo -e "${C}${LP} _______ _______ ______ _____ ____  "
        echo -e "${C}${LP}|__   __|_   _\ \/ /  _ \_   _/ __ \ "
        echo -e "${G}${LP}   | |    | |  \  /| |_) || || |  | |"
        echo -e "${G}${LP}   | |   _| |_ /  \|  _ < | || |__| |"
        echo -e "${R}${LP}   |_|  |_____/_/\_\_| \_\_____\____/ ${RS}"
        echo -e "${R}${LP}         TYRAN ROOT OS v1.1${RS}"
    elif [ "$BANNER_STYLE" = "3" ]; then
        if command -v figlet &>/dev/null; then
            figlet "TyranRoot" 2>/dev/null | while IFS= read -r line; do
                echo -e "${C}${LP}$line${RS}"
            done
        else
            echo -e "${C}${LP}  TyranRoot OS${RS}"
        fi
    fi

    echo -e ""
    cline "╔" "╗"
    cmid  "TyranRoot OS — Termux Customization v1.1" "$W"
    cmid  "Fixed for Termux Compatibility" "$DIM"
    cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${R}[!]${W} User     : ${C}${USERNAME}${RS}"
    echo -e "${LP}  ${R}[!]${W} Host     : ${C}${HOSTNAME}${RS}"
    echo -e "${LP}  ${R}[!]${W} Shell    : ${C}$(basename $SHELL)${RS}"
    echo -e "${LP}  ${R}[!]${W} Prompt   : ${C}${PROMPT_STYLE}${RS}"
    echo -e ""
}

# ── INSTALL PACKAGES ─────────────────────────────────────────
install_base() {
    echo -e "\n${LP}${Y}[▶] Installing base packages...${RS}\n"
    pkg update -y && pkg upgrade -y
    pkg install -y zsh fish git curl wget figlet toilet ruby bat eza lsd neofetch
    gem install lolcat 2>/dev/null || echo -e "${LP}${Y}[!] lolcat install skipped${RS}"
    echo -e "\n${LP}${G}[✔] Base packages installed.${RS}"
    press_enter; menu
}

# ── APPLY ZSH PROMPT ─────────────────────────────────────────
apply_zsh_prompt() {
    local style="$1"
    local user="$USERNAME"
    local host="$HOSTNAME"

    # Remove old TyranRoot prompt
    sed -i '/# TyranRoot.*prompt/,/^$/d' ~/.zshrc 2>/dev/null

    case "$style" in
        kali)
            cat >> ~/.zshrc <<'ZSH'
# TyranRoot Kali-style prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b)'
setopt PROMPT_SUBST
PROMPT='%F{red}┌──(%F{cyan}'${user}'㉿'${host}'%F{red})-[%F{white}%~%F{red}]%f$(vcs_info_msg_0_)
%F{red}└─%F{white}$ %f'
ZSH
            ;;
        arrow)
            cat >> ~/.zshrc <<ZSH
# TyranRoot Arrow prompt
PROMPT='%F{cyan}╔═[%F{white}'${user}'@'${host}'%F{cyan}]═[%F{green}%~%F{cyan}]
%F{cyan}╚═▶ %F{white}%f'
ZSH
            ;;
        minimal)
            cat >> ~/.zshrc <<ZSH
# TyranRoot Minimal prompt
PROMPT='%F{cyan}'${user}'%F{white}@%F{red}'${host}' %F{green}%~ %F{yellow}❯ %f'
ZSH
            ;;
        hacker)
            cat >> ~/.zshrc <<ZSH
# TyranRoot Hacker prompt
PROMPT='%F{green}[%F{white}root@'${host}'%F{green}]-[%F{red}%~%F{green}]
%F{green}# %f'
ZSH
            ;;
        powerline)
            cat >> ~/.zshrc <<ZSH
# TyranRoot Powerline prompt
PROMPT='%K{blue}%F{white} '${user}' %k%K{cyan}%F{blue}%F{black} '${host}' %k%K{green}%F{cyan}%F{black} %~ %k%F{green} %f'
ZSH
            ;;
    esac
    echo -e "${LP}${G}[✔] Zsh prompt applied: ${style}${RS}"
}

# ── APPLY FISH PROMPT ────────────────────────────────────────
apply_fish_prompt() {
    local style="$1"
    local user="$USERNAME"
    local host="$HOSTNAME"
    mkdir -p ~/.config/fish/functions

    case "$style" in
        kali)
            cat > ~/.config/fish/functions/fish_prompt.fish <<FISH
function fish_prompt
    set_color red
    echo -n "┌──("
    set_color cyan
    echo -n "${user}㉿${host}"
    set_color red
    echo -n ")-["
    set_color white
    echo -n (prompt_pwd)
    set_color red
    echo -n "]"
    echo
    set_color red
    echo -n "└─"
    set_color white
    echo -n "\$ "
    set_color normal
end
FISH
            ;;
        arrow)
            cat > ~/.config/fish/functions/fish_prompt.fish <<FISH
function fish_prompt
    set_color cyan
    echo -n "╔═["
    set_color white
    echo -n "${user}@${host}"
    set_color cyan
    echo -n "]═["
    set_color green
    echo -n (prompt_pwd)
    set_color cyan
    echo -n "]"
    echo
    set_color cyan
    echo -n "╚═▶ "
    set_color normal
end
FISH
            ;;
        hacker)
            cat > ~/.config/fish/functions/fish_prompt.fish <<FISH
function fish_prompt
    set_color green
    echo -n "[root@${host}]-["
    set_color red
    echo -n (prompt_pwd)
    set_color green
    echo -n "]"
    echo
    echo -n "# "
    set_color normal
end
FISH
            ;;
        minimal)
            cat > ~/.config/fish/functions/fish_prompt.fish <<FISH
function fish_prompt
    set_color cyan
    echo -n "${user}"
    set_color white
    echo -n "@"
    set_color red
    echo -n "${host}"
    set_color green
    echo -n " "(prompt_pwd)
    set_color yellow
    echo -n " ❯ "
    set_color normal
end
FISH
            ;;
    esac
    echo -e "${LP}${G}[✔] Fish prompt applied: ${style}${RS}"
}

# ── APPLY BASH PROMPT ────────────────────────────────────────
apply_bash_prompt() {
    local style="$1"
    local user="$USERNAME"
    local host="$HOSTNAME"

    # Remove old
    sed -i '/# TyranRoot prompt/,/^$/d' ~/.bashrc 2>/dev/null

    case "$style" in
        kali)
            cat >> ~/.bashrc <<BASH
# TyranRoot prompt
PS1='\[\033[1;31m\]┌──(\[\033[1;36m\]${user}㉿${host}\[\033[1;31m\])-[\[\033[1;37m\]\w\[\033[1;31m\]]\n└─\[\033[1;37m\]\$ \[\033[0m\]'
BASH
            ;;
        hacker)
            cat >> ~/.bashrc <<BASH
# TyranRoot prompt
PS1='\[\033[1;32m\][root@${host}]-[\[\033[1;31m\]\w\[\033[1;32m\]]\n# \[\033[0m\]'
BASH
            ;;
        arrow)
            cat >> ~/.bashrc <<BASH
# TyranRoot prompt
PS1='\[\033[1;36m\]╔═[\[\033[1;37m\]${user}@${host}\[\033[1;36m\]]═[\[\033[1;32m\]\w\[\033[1;36m\]]\n╚═▶ \[\033[0m\]'
BASH
            ;;
        minimal)
            cat >> ~/.bashrc <<BASH
# TyranRoot prompt
PS1='\[\033[1;36m\]${user}\[\033[1;37m\]@\[\033[1;31m\]${host} \[\033[1;32m\]\w \[\033[1;33m\]❯ \[\033[0m\]'
BASH
            ;;
    esac
    echo -e "${LP}${G}[✔] Bash prompt applied: ${style}${RS}"
}

# ── CHANGE SHELL (Termux compatible) ────────────────────────
change_shell() {
    local shell="$1"
    local shell_path
    case "$shell" in
        zsh)  shell_path="$(which zsh 2>/dev/null || echo "/data/data/com.termux/files/usr/bin/zsh")" ;;
        fish) shell_path="$(which fish 2>/dev/null || echo "/data/data/com.termux/files/usr/bin/fish")" ;;
        bash) shell_path="$(which bash 2>/dev/null || echo "/data/data/com.termux/files/usr/bin/bash")" ;;
    esac
    
    if [ -f "$shell_path" ]; then
        # Termux uses ~/.termux/shell
        echo "$shell_path" > ~/.termux/shell
        termux-reload-settings 2>/dev/null
        echo -e "${LP}${G}[✔] Shell set to $shell. Restart Termux to apply.${RS}"
    else
        echo -e "${LP}${R}[✘] $shell not installed. Install first.${RS}"
    fi
}

# ── INSTALL ZSH PLUGINS ──────────────────────────────────────
install_zsh_plugins() {
    echo -e "\n${LP}${Y}[▶] Installing Zsh plugins...${RS}\n"

    # Oh-My-Zsh
    if [ ! -d ~/.oh-my-zsh ]; then
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    fi
    
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Syntax highlighting
    local HL="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    [ -d "$HL" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$HL"

    # Autosuggestions
    local AS="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [ -d "$AS" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$AS"

    # Update .zshrc
    if [ -f ~/.zshrc ]; then
        sed -i 's/^plugins=.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
    fi

    echo -e "${LP}${G}[✔] Plugins installed: syntax-highlighting, autosuggestions${RS}"
    press_enter; zsh_menu
}

# ── INSTALL FISH PLUGINS ─────────────────────────────────────
install_fish_plugins() {
    echo -e "\n${LP}${Y}[▶] Installing Fish plugins...${RS}\n"
    pkg install fish -y

    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" 2>/dev/null
    fish -c "fisher install jorgebucaran/autopair.fish" 2>/dev/null

    echo -e "${LP}${G}[✔] Fish plugins installed${RS}"
    press_enter; fish_menu
}

# ── NERD FONT ─────────────────────────────────────────────────
install_font() {
    echo -e "\n${LP}${Y}[▶] Installing FiraCode Nerd Font...${RS}\n"
    mkdir -p ~/.termux
    curl -fL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf" \
         -o ~/.termux/font.ttf && \
    echo -e "${LP}${G}[✔] Font installed. Restart Termux to apply.${RS}" || \
    echo -e "${LP}${R}[✘] Font download failed. Check internet.${RS}"
    termux-reload-settings 2>/dev/null
    press_enter; appearance_menu
}

# ── COLORS.PROPERTIES ─────────────────────────────────────────
apply_color_theme() {
    local theme="$1"
    mkdir -p ~/.termux
    case "$theme" in
        hacker)
            cat > ~/.termux/colors.properties <<'COL'
background=#020c06
foreground=#00ff41
cursor=#00ff41
color0=#020c06
color1=#ff2244
color2=#00ff41
color3=#ffcc00
color4=#00ccff
color5=#cc00ff
color6=#00ffcc
color7=#b0ffb0
color8=#1a3a22
color9=#ff4466
color10=#33ff66
color11=#ffdd44
color12=#33ddff
color13=#dd33ff
color14=#33ffdd
color15=#e0ffe0
COL
            ;;
        kali)
            cat > ~/.termux/colors.properties <<'COL'
background=#1a1a2e
foreground=#e0e0e0
cursor=#00d4ff
color0=#1a1a2e
color1=#ff4444
color2=#44ff88
color3=#ffcc00
color4=#4488ff
color5=#cc44ff
color6=#44ffcc
color7=#e0e0e0
color8=#2a2a4e
color9=#ff6666
color10=#66ffaa
color11=#ffdd44
color12=#66aaff
color13=#dd66ff
color14=#66ffdd
color15=#ffffff
COL
            ;;
        dracula)
            cat > ~/.termux/colors.properties <<'COL'
background=#282a36
foreground=#f8f8f2
cursor=#f8f8f2
color0=#21222c
color1=#ff5555
color2=#50fa7b
color3=#f1fa8c
color4=#bd93f9
color5=#ff79c6
color6=#8be9fd
color7=#f8f8f2
color8=#6272a4
color9=#ff6e6e
color10=#69ff94
color11=#ffffa5
color12=#d6acff
color13=#ff92df
color14=#a4ffff
color15=#ffffff
COL
            ;;
        matrix)
            cat > ~/.termux/colors.properties <<'COL'
background=#000000
foreground=#00ff00
cursor=#00ff00
color0=#000000
color1=#003300
color2=#00ff00
color3=#009900
color4=#006600
color5=#00cc00
color6=#33ff33
color7=#00ff00
color8=#002200
color9=#004400
color10=#00dd00
color11=#00bb00
color12=#008800
color13=#00ee00
color14=#44ff44
color15=#66ff66
COL
            ;;
    esac
    termux-reload-settings 2>/dev/null
    echo -e "${LP}${G}[✔] Theme applied: ${theme}${RS}"
}

# ── CHANGE USERNAME / HOSTNAME ───────────────────────────────
change_identity() {
    echo -e "\n${LP}${C}Current: ${W}${USERNAME}${C}㉿${W}${HOSTNAME}${RS}"
    echo -ne "${LP}${Y}New username (Enter to keep '${USERNAME}'): ${RS}"
    read -r new_user
    echo -ne "${LP}${Y}New hostname (Enter to keep '${HOSTNAME}'): ${RS}"
    read -r new_host

    [ -n "$new_user" ] && USERNAME="$new_user"
    [ -n "$new_host" ] && HOSTNAME="$new_host"

    cat > "$CONFIG" <<CONF
USERNAME=$USERNAME
HOSTNAME=$HOSTNAME
SHELL_COLOR=$SHELL_COLOR
PROMPT_STYLE=$PROMPT_STYLE
BANNER_STYLE=$BANNER_STYLE
CONF

    echo -e "${LP}${G}[✔] Identity updated: ${USERNAME}㉿${HOSTNAME}${RS}"
    press_enter; identity_menu
}

# ── SECURITY LOCK ────────────────────────────────────────────
do_add_lock() {
    echo -e "\n${LP}${C}[▶] Setting up terminal security lock...${RS}"
    echo -ne "${LP}${Y}Create Access Key: ${RS}"
    read -rs new_pass; echo

    local lock_bash=$(cat <<LOCKBASH
#TYRANLOCK_START
clear
echo -e '\033[1;32m  Initializing...\033[0m'
sleep 0.3; clear
_tl_attempt=1
while [ \$_tl_attempt -le 3 ]; do
    echo -e "\n\033[1;36m╔══════════════════════════════════════╗"
    echo -e "║  \033[1;31m⬡ TYRANROOT — SECURE ACCESS \033[1;36m        ║"
    echo -e "╚══════════════════════════════════════╝\033[0m"
    echo -ne "\033[1;33m  [Attempt \$_tl_attempt/3] Access Key: \033[0m"
    read -rs _tl_pass; echo
    if [ "\$_tl_pass" = "$new_pass" ]; then
        echo -e "\033[1;32m  ✔ ACCESS GRANTED\033[0m"; sleep 0.8; clear; break
    else
        echo -e "\033[1;31m  ✘ DENIED\033[0m"
        [ \$_tl_attempt -eq 3 ] && exit 1
        _tl_attempt=\$((_tl_attempt+1)); sleep 0.5
    fi
done
#TYRANLOCK_END
LOCKBASH
)

    for rcfile in ~/.bashrc ~/.zshrc; do
        [ -f "$rcfile" ] || continue
        sed -i '/#TYRANLOCK_START/,/#TYRANLOCK_END/d' "$rcfile"
        echo "$lock_bash" > "$rcfile.tmp"
        cat "$rcfile" >> "$rcfile.tmp"
        mv "$rcfile.tmp" "$rcfile"
    done

    echo -e "${LP}${G}[✔] Security lock added.${RS}"
    press_enter; security_menu
}

do_remove_lock() {
    for rcfile in ~/.bashrc ~/.zshrc ~/.config/fish/config.fish; do
        [ -f "$rcfile" ] && sed -i '/#TYRANLOCK_START/,/#TYRANLOCK_END/d' "$rcfile"
    done
    echo -e "${LP}${G}[✔] Security lock removed.${RS}"
    press_enter; security_menu
}

# ── MOTD / NEOFETCH BANNER ───────────────────────────────────
setup_motd() {
    local choice="$1"
    rm -f /data/data/com.termux/files/usr/etc/motd 2>/dev/null

    if [ "$choice" = "neofetch" ]; then
        pkg install neofetch -y 2>/dev/null
        grep -q "neofetch" ~/.bashrc 2>/dev/null || echo -e "\n# TyranRoot MOTD\nneofetch" >> ~/.bashrc
        grep -q "neofetch" ~/.zshrc 2>/dev/null || echo -e "\n# TyranRoot MOTD\nneofetch" >> ~/.zshrc
        echo -e "${LP}${G}[✔] Neofetch set as startup banner.${RS}"
    elif [ "$choice" = "custom" ]; then
        local banner_cmd='echo -e "\033[1;36m"; figlet "TyranRoot" 2>/dev/null; echo -e "\033[1;32m  Termux OS v1.1 | TyranRoot\033[0m\n"'
        for rcfile in ~/.bashrc ~/.zshrc; do
            [ -f "$rcfile" ] || continue
            grep -q "TyranRoot MOTD" "$rcfile" || echo -e "\n# TyranRoot MOTD\n$banner_cmd" >> "$rcfile"
        done
        echo -e "${LP}${G}[✔] Custom ASCII banner set as startup.${RS}"
    elif [ "$choice" = "remove" ]; then
        for rcfile in ~/.bashrc ~/.zshrc; do
            [ -f "$rcfile" ] && sed -i '/# TyranRoot MOTD/,+1d' "$rcfile"
        done
        echo -e "${LP}${G}[✔] Startup banner removed.${RS}"
    fi
    press_enter; appearance_menu
}

# ════════════════════════════════════════
#  MENUS
# ════════════════════════════════════════
menu() {
    banner
    cline "╔" "╗"
    cmid  "MAIN MENU" "$C"
    cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} 📦 Install Base Packages"
    echo -e "${LP}  ${C}[${W}02${C}]${G} 🐚 Zsh Options"
    echo -e "${LP}  ${C}[${W}03${C}]${G} 🐟 Fish Options"
    echo -e "${LP}  ${C}[${W}04${C}]${G} 💻 Bash Options"
    echo -e "${LP}  ${C}[${W}05${C}]${Y} 🎨 Appearance & Themes"
    echo -e "${LP}  ${C}[${W}06${C}]${M} 👤 Identity (Username/Hostname)"
    echo -e "${LP}  ${C}[${W}07${C}]${B} 🔒 Security"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ✖  Exit"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) install_base     ;;
        2|02) zsh_menu         ;;
        3|03) fish_menu        ;;
        4|04) bash_menu        ;;
        5|05) appearance_menu  ;;
        6|06) identity_menu    ;;
        7|07) security_menu    ;;
        0|00) echo -e "\n${LP}${C}Goodbye, ${USERNAME}. Stay hacking. 🔐${RS}\n"; exit 0 ;;
        *)    menu             ;;
    esac
}

# ── ZSH MENU ─────────────────────────────────────────────────
zsh_menu() {
    banner
    cline "╔" "╗"; cmid "ZSH OPTIONS" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} Install Oh-My-Zsh"
    echo -e "${LP}  ${C}[${W}02${C}]${G} Switch to Zsh"
    echo -e "${LP}  ${C}[${W}03${C}]${Y} Install Plugins"
    echo -e "${LP}  ${C}[${W}04${C}]${Y} Apply Prompt Style"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) echo -e "\n${LP}${Y}Installing Oh-My-Zsh...${RS}"
              [ -d ~/.oh-my-zsh ] || git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
              [ -f ~/.zshrc ] || cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
              echo -e "${LP}${G}[✔] Done.${RS}"; press_enter; zsh_menu ;;
        2|02) change_shell "zsh"; press_enter; zsh_menu ;;
        3|03) install_zsh_plugins ;;
        4|04) prompt_style_menu "zsh" ;;
        0|00) menu ;;
        *)    zsh_menu ;;
    esac
}

# ── FISH MENU ─────────────────────────────────────────────────
fish_menu() {
    banner
    cline "╔" "╗"; cmid "FISH OPTIONS" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} Install Fish"
    echo -e "${LP}  ${C}[${W}02${C}]${G} Switch to Fish"
    echo -e "${LP}  ${C}[${W}03${C}]${Y} Install Fish Plugins"
    echo -e "${LP}  ${C}[${W}04${C}]${Y} Apply Prompt Style"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) pkg install fish -y; echo -e "${LP}${G}[✔] Fish installed.${RS}"; press_enter; fish_menu ;;
        2|02) change_shell "fish"; press_enter; fish_menu ;;
        3|03) install_fish_plugins ;;
        4|04) prompt_style_menu "fish" ;;
        0|00) menu ;;
        *)    fish_menu ;;
    esac
}

# ── BASH MENU ─────────────────────────────────────────────────
bash_menu() {
    banner
    cline "╔" "╗"; cmid "BASH OPTIONS" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} Switch to Bash"
    echo -e "${LP}  ${C}[${W}02${C}]${Y} Apply Prompt Style"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) change_shell "bash"; press_enter; bash_menu ;;
        2|02) prompt_style_menu "bash" ;;
        0|00) menu ;;
        *)    bash_menu ;;
    esac
}

# ── PROMPT STYLE MENU ────────────────────────────────────────
prompt_style_menu() {
    local shell="$1"
    banner
    cline "╔" "╗"; cmid "PROMPT STYLE — ${shell^^}" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} Kali Linux Style"
    echo -e "${LP}  ${DIM}       ┌──(${USERNAME}㉿${HOSTNAME})-[~]"
    echo -e "${LP}       └─\$${RS}"
    echo -e ""
    echo -e "${LP}  ${C}[${W}02${C}]${G} Arrow Style"
    echo -e "${LP}  ${DIM}       ╔═[${USERNAME}@${HOSTNAME}]═[~]"
    echo -e "${LP}       ╚═▶ ${RS}"
    echo -e ""
    echo -e "${LP}  ${C}[${W}03${C}]${G} Minimal Style"
    echo -e "${LP}  ${DIM}       ${USERNAME}@${HOSTNAME} ~ ❯ ${RS}"
    echo -e ""
    echo -e "${LP}  ${C}[${W}04${C}]${G} Hacker Style"
    echo -e "${LP}  ${DIM}       [root@${HOSTNAME}]-[~]"
    echo -e "${LP}       # ${RS}"
    echo -e ""
    [ "$shell" = "zsh" ] && echo -e "${LP}  ${C}[${W}05${C}]${G} Powerline Style"
    echo -e ""
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a

    case $a in
        1|01) PROMPT_STYLE="kali";      apply_${shell}_prompt "kali"      ;;
        2|02) PROMPT_STYLE="arrow";     apply_${shell}_prompt "arrow"     ;;
        3|03) PROMPT_STYLE="minimal";   apply_${shell}_prompt "minimal"   ;;
        4|04) PROMPT_STYLE="hacker";    apply_${shell}_prompt "hacker"    ;;
        5|05) [ "$shell" = "zsh" ] && { PROMPT_STYLE="powerline"; apply_zsh_prompt "powerline"; } ;;
        0|00) eval "${shell}_menu"; return ;;
        *)    prompt_style_menu "$shell"; return ;;
    esac

    sed -i "s/^PROMPT_STYLE=.*/PROMPT_STYLE=$PROMPT_STYLE/" "$CONFIG"
    echo -e "${LP}${Y}[!] Restart shell or run: source ~/.${shell}rc${RS}"
    press_enter
    eval "${shell}_menu"
}

# ── APPEARANCE MENU ───────────────────────────────────────────
appearance_menu() {
    banner
    cline "╔" "╗"; cmid "APPEARANCE & THEMES" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} Install FiraCode Nerd Font"
    echo -e "${LP}  ${C}[${W}02${C}]${Y} Color Theme: Hacker Green"
    echo -e "${LP}  ${C}[${W}03${C}]${B} Color Theme: Kali Dark"
    echo -e "${LP}  ${C}[${W}04${C}]${M} Color Theme: Dracula"
    echo -e "${LP}  ${C}[${W}05${C}]${G} Color Theme: Matrix Black"
    echo -e "${LP}  ${C}[${W}06${C}]${W} Startup Banner: Neofetch"
    echo -e "${LP}  ${C}[${W}07${C}]${W} Startup Banner: Custom ASCII"
    echo -e "${LP}  ${C}[${W}08${C}]${R} Remove Startup Banner"
    echo -e "${LP}  ${C}[${W}09${C}]${Y} Change Banner Style"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) install_font ;;
        2|02) apply_color_theme "hacker";  press_enter; appearance_menu ;;
        3|03) apply_color_theme "kali";    press_enter; appearance_menu ;;
        4|04) apply_color_theme "dracula"; press_enter; appearance_menu ;;
        5|05) apply_color_theme "matrix";  press_enter; appearance_menu ;;
        6|06) setup_motd "neofetch" ;;
        7|07) setup_motd "custom"   ;;
        8|08) setup_motd "remove"   ;;
        9|09) banner_style_menu ;;
        0|00) menu ;;
        *)    appearance_menu ;;
    esac
}

# ── BANNER STYLE MENU ────────────────────────────────────────
banner_style_menu() {
    banner
    cline "╔" "╗"; cmid "BANNER STYLE" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} Style 1 — Block Unicode"
    echo -e "${LP}  ${C}[${W}02${C}]${G} Style 2 — Compact ASCII"
    echo -e "${LP}  ${C}[${W}03${C}]${G} Style 3 — Figlet"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) BANNER_STYLE=1; sed -i "s/^BANNER_STYLE=.*/BANNER_STYLE=1/" "$CONFIG"; appearance_menu ;;
        2|02) BANNER_STYLE=2; sed -i "s/^BANNER_STYLE=.*/BANNER_STYLE=2/" "$CONFIG"; appearance_menu ;;
        3|03) BANNER_STYLE=3; sed -i "s/^BANNER_STYLE=.*/BANNER_STYLE=3/" "$CONFIG"; appearance_menu ;;
        0|00) appearance_menu ;;
        *)    banner_style_menu ;;
    esac
}

# ── IDENTITY MENU ─────────────────────────────────────────────
identity_menu() {
    banner
    cline "╔" "╗"; cmid "IDENTITY SETTINGS" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${G} Change Username & Hostname"
    echo -e "${LP}  ${C}[${W}02${C}]${Y} Change Prompt Color"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -e "${LP}  ${DIM}Current: ${USERNAME}㉿${HOSTNAME} | Color: ${SHELL_COLOR}${RS}"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) change_identity ;;
        2|02)
            echo -e "${LP}${Y}Colors: red green yellow blue magenta cyan white${RS}"
            echo -ne "${LP}${C}Color ❯ ${RS}"
            read -r nc
            if [[ "$nc" =~ ^(red|green|yellow|blue|magenta|cyan|white)$ ]]; then
                SHELL_COLOR="$nc"
                sed -i "s/^SHELL_COLOR=.*/SHELL_COLOR=$nc/" "$CONFIG"
                echo -e "${LP}${G}[✔] Color set to ${nc}.${RS}"
            else
                echo -e "${LP}${R}[✘] Invalid color.${RS}"
            fi
            press_enter; identity_menu ;;
        0|00) menu ;;
        *)    identity_menu ;;
    esac
}

# ── SECURITY MENU ─────────────────────────────────────────────
security_menu() {
    banner
    cline "╔" "╗"; cmid "SECURITY" "$C"; cline "╚" "╝"
    echo -e ""
    echo -e "${LP}  ${C}[${W}01${C}]${B} Add Terminal Lock (Access Key)"
    echo -e "${LP}  ${C}[${W}02${C}]${R} Remove Terminal Lock"
    echo -e "${LP}  ${C}[${W}00${C}]${R} ← Back"
    echo -e ""
    echo -ne "${LP}${C}Selection ❯ ${RS}"
    read -r a
    case $a in
        1|01) do_add_lock    ;;
        2|02) do_remove_lock ;;
        0|00) menu ;;
        *)    security_menu  ;;
    esac
}

# ── ENTRY POINT ───────────────────────────────────────────────
menu
