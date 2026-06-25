#!/data/data/com.termux/files/usr/bin/bash

# ═══════════════════════════════════════════════
#   Ter-Chan — Termux Customization Tool v3.0
#   Bash Edition | Zsh Focused
# ═══════════════════════════════════════════════

R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
M='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
DIM='\033[2m'
RS='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.terchan_config"
ZSHRC="$HOME/.zshrc"

# ── Config ────────────────────────────────────
load_config() {
    USERNAME="TyranRoot"
    HOSTNAME="Termux"
    PROMPT_STYLE="kali"
    BANNER_TYPE="figlet"
    BANNER_TEXT="Ter-Chan"
    BANNER_COLOR="random"

    if [ -f "$CONFIG" ]; then
        while IFS='=' read -r key val; do
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            case "$key" in
                USERNAME)     USERNAME="$val"     ;;
                HOSTNAME)     HOSTNAME="$val"     ;;
                PROMPT_STYLE) PROMPT_STYLE="$val" ;;
                BANNER_TYPE)  BANNER_TYPE="$val"  ;;
                BANNER_TEXT)  BANNER_TEXT="$val"  ;;
                BANNER_COLOR) BANNER_COLOR="$val" ;;
            esac
        done < "$CONFIG"
    else
        save_config
    fi
}

save_config() {
    cat > "$CONFIG" <<EOF
USERNAME=$USERNAME
HOSTNAME=$HOSTNAME
PROMPT_STYLE=$PROMPT_STYLE
BANNER_TYPE=$BANNER_TYPE
BANNER_TEXT=$BANNER_TEXT
BANNER_COLOR=$BANNER_COLOR
EOF
}

# ── Remove block from zshrc ───────────────────
remove_block() {
    local marker="$1"
    local file="$ZSHRC"
    [ ! -f "$file" ] && return
    local tmp="$file.tmp"
    local inside=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == "# >>>TERCHAN:${marker}:START" ]]; then
            inside=1; continue
        fi
        if [[ "$line" == "# >>>TERCHAN:${marker}:END" ]]; then
            inside=0; continue
        fi
        [ $inside -eq 0 ] && echo "$line"
    done < "$file" > "$tmp"
    mv "$tmp" "$file"
}

write_block() {
    local marker="$1"
    local content="$2"
    remove_block "$marker"
    {
        echo ""
        echo "# >>>TERCHAN:${marker}:START"
        echo "$content"
        echo "# >>>TERCHAN:${marker}:END"
    } >> "$ZSHRC"
}

# ── Apply banner + prompt to .zshrc ──────────
apply_all() {
    # ── Banner ──
    local banner_cmd=""
    if [ "$BANNER_TYPE" = "figlet" ]; then
        if [ "$BANNER_COLOR" = "random" ]; then
            banner_cmd="figlet -f slant \"${BANNER_TEXT}\" | lolcat"
        else
            case "$BANNER_COLOR" in
                red)     clr='\033[1;31m' ;;
                green)   clr='\033[1;32m' ;;
                yellow)  clr='\033[1;33m' ;;
                blue)    clr='\033[1;34m' ;;
                magenta) clr='\033[1;35m' ;;
                *)       clr='\033[1;36m' ;;
            esac
            banner_cmd="echo -e \"${clr}\"; figlet -f slant \"${BANNER_TEXT}\"; echo -e \"\033[0m\""
        fi
    elif [ "$BANNER_TYPE" = "neofetch" ]; then
        banner_cmd="neofetch"
    elif [ "$BANNER_TYPE" = "both" ]; then
        banner_cmd="figlet -f slant \"${BANNER_TEXT}\" | lolcat
neofetch"
    fi

    write_block "BANNER" "$banner_cmd"

    # ── Prompt ──
    local prompt_block=""
    case "$PROMPT_STYLE" in
        kali)
            prompt_block="autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{red}┌──(%F{cyan}${USERNAME}%F{white}@%F{green}${HOSTNAME}%F{red})-[%F{white}%~%F{red}]\${vcs_info_msg_0_}
%F{red}└─%F{white}\$ %f'"
            ;;
        arrow)
            prompt_block="setopt PROMPT_SUBST
PROMPT='%F{cyan}╔═[%F{white}${USERNAME}%F{cyan}@%F{green}${HOSTNAME}%F{cyan}]═[%F{yellow}%~%F{cyan}]
%F{cyan}╚═▶ %F{white}%f'"
            ;;
        minimal)
            prompt_block="setopt PROMPT_SUBST
PROMPT='%F{cyan}${USERNAME}%F{white}@%F{red}${HOSTNAME} %F{green}%~ %F{yellow}❯ %f'"
            ;;
        hacker)
            prompt_block="setopt PROMPT_SUBST
PROMPT='%F{green}[%F{white}root@${HOSTNAME}%F{green}]-[%F{red}%~%F{green}]
%F{green}# %f'"
            ;;
        powerline)
            prompt_block="setopt PROMPT_SUBST
PROMPT='%K{blue}%F{white} ${USERNAME} %k%K{cyan}%F{black} ${HOSTNAME} %k%K{green}%F{black} %~ %k%F{green}▶%f '"
            ;;
    esac

    write_block "PROMPT" "$prompt_block"

    echo -e "\n${G}[✔] .zshrc updated successfully!${RS}"
    echo -e "${Y}[!] Run: source ~/.zshrc  — or restart Termux${RS}\n"
}

# ── Tool Banner ───────────────────────────────
banner() {
    clear

    echo -e ""
    echo -e "${C} ______          _____ _"
    echo -e "${C}/_  __/__ ____  / ___/| |"
    echo -e "${G} / / / -_) __/ / /__  | |__  __ _ _ __"
    echo -e "${G}/_/  \__/_/    \___/  |____||__,_|_/  \\"
    echo -e "${R}                    | |__  __ _ _ __"
    echo -e "${R}                    |____||__,_|_/  \\ ${RS}"
    echo -e ""
    echo -e "${W}      --[ ${G}Ter-Chan Termux Tool v3.0 ${W}]--"
    echo -e ""
    echo -e "${R} [!]${W} User    : ${C}${USERNAME}"
    echo -e "${R} [!]${W} Host    : ${C}${HOSTNAME}"
    echo -e "${R} [!]${W} Prompt  : ${C}${PROMPT_STYLE}"
    echo -e "${R} [!]${W} Banner  : ${C}${BANNER_TYPE} / ${BANNER_TEXT} / ${BANNER_COLOR}"
    echo -e ""
    echo -e "${G} ==============================================${RS}"
    echo -e ""
}

press_enter() {
    echo -e "\n${DIM}Press Enter to continue...${RS}"
    read -r
}

# ── Install Dependencies ──────────────────────
do_install_deps() {
    echo -e "\n${Y}[▶] Updating packages...${RS}"
    pkg update -y && pkg upgrade -y

    echo -e "\n${Y}[▶] Installing required packages...${RS}"
    pkg install -y zsh git curl wget figlet toilet ruby neofetch

    echo -e "\n${Y}[▶] Installing lolcat...${RS}"
    gem install lolcat 2>/dev/null || echo -e "${Y}[!] lolcat may need manual install${RS}"

    # Oh-My-Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "\n${Y}[▶] Installing Oh-My-Zsh...${RS}"
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
        [ ! -f "$ZSHRC" ] && cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$ZSHRC"
    fi

    # Plugins
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local HL="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    local AS="$ZSH_CUSTOM/plugins/zsh-autosuggestions"

    if [ ! -d "$HL" ]; then
        echo -e "\n${Y}[▶] Installing zsh-syntax-highlighting...${RS}"
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$HL"
    fi
    if [ ! -d "$AS" ]; then
        echo -e "\n${Y}[▶] Installing zsh-autosuggestions...${RS}"
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$AS"
    fi

    # Enable plugins
    if [ -f "$ZSHRC" ]; then
        sed -i 's/^plugins=.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' "$ZSHRC"
    fi

    # Set zsh as default
    local zsh_path="/data/data/com.termux/files/usr/bin/zsh"
    if [ -f "$zsh_path" ]; then
        mkdir -p "$HOME/.termux"
        echo "$zsh_path" > "$HOME/.termux/shell"
        termux-reload-settings 2>/dev/null || true
    fi

    echo -e "\n${G}[✔] All done!${RS}"
    press_enter
    menu
}

# ── Nerd Font ─────────────────────────────────
do_install_font() {
    echo -e "\n${Y}[▶] Installing FiraCode Nerd Font...${RS}\n"
    mkdir -p "$HOME/.termux"
    if curl -fL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf" \
        -o "$HOME/.termux/font.ttf"; then
        termux-reload-settings 2>/dev/null || true
        echo -e "${G}[✔] Font installed. Restart Termux.${RS}"
    else
        echo -e "${R}[✘] Download failed. Check internet.${RS}"
    fi
    press_enter
    appearance_menu
}

# ── Color Themes ──────────────────────────────
apply_color_theme() {
    local theme="$1"
    mkdir -p "$HOME/.termux"
    local file="$HOME/.termux/colors.properties"

    case "$theme" in
        hacker)
cat > "$file" <<'EOF'
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
EOF
            ;;
        kali)
cat > "$file" <<'EOF'
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
EOF
            ;;
        dracula)
cat > "$file" <<'EOF'
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
EOF
            ;;
        matrix)
cat > "$file" <<'EOF'
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
EOF
            ;;
        catppuccin)
cat > "$file" <<'EOF'
background=#1e1e2e
foreground=#cdd6f4
cursor=#f5e0dc
color0=#45475a
color1=#f38ba8
color2=#a6e3a1
color3=#f9e2af
color4=#89b4fa
color5=#f5c2e7
color6=#94e2d5
color7=#bac2de
color8=#585b70
color9=#f38ba8
color10=#a6e3a1
color11=#f9e2af
color12=#89b4fa
color13=#f5c2e7
color14=#94e2d5
color15=#a6adc8
EOF
            ;;
    esac

    termux-reload-settings 2>/dev/null || true
    echo -e "${G}[✔] Theme applied: ${theme}${RS}"
}

# ── Security Lock ─────────────────────────────
do_add_lock() {
    echo -e "\n${C}[▶] Setting up terminal lock...${RS}"
    echo -ne "${Y}Create Access Key: ${RS}"
    read -rs new_pass
    echo

    local lock_code
    lock_code=$(cat <<LOCKEOF
clear
echo -e '\033[1;32m  Initializing...\033[0m'
sleep 0.3
clear
_tc_attempt=1
while [ \$_tc_attempt -le 3 ]; do
    echo -e "\n\033[1;36m╔══════════════════════════════════════╗"
    echo -e "║  \033[1;31m⬡ TER-CHAN — SECURE ACCESS \033[1;36m         ║"
    echo -e "╚══════════════════════════════════════╝\033[0m"
    echo -ne "\033[1;33m  [Attempt \$_tc_attempt/3] Access Key: \033[0m"
    read -rs _tc_pass
    echo
    if [ "\$_tc_pass" = "${new_pass}" ]; then
        echo -e "\033[1;32m  ✔ ACCESS GRANTED\033[0m"
        sleep 0.5
        clear
        break
    else
        echo -e "\033[1;31m  ✘ DENIED\033[0m"
        [ \$_tc_attempt -eq 3 ] && exit 1
        _tc_attempt=\$((_tc_attempt+1))
        sleep 0.5
    fi
done
LOCKEOF
)
    write_block "LOCK" "$lock_code"
    echo -e "${G}[✔] Lock added to .zshrc${RS}"
    press_enter
    security_menu
}

do_remove_lock() {
    remove_block "LOCK"
    echo -e "${G}[✔] Lock removed from .zshrc${RS}"
    press_enter
    security_menu
}

# ══════════════════════════════════════════════
#  MENUS
# ══════════════════════════════════════════════

menu() {
    load_config
    banner

    printf "${C}[${W}01${C}]${G} Necessary Setup\n"
    printf "${C}[${W}02${C}]${G} Zsh Options\n"
    printf "${C}[${W}03${C}]${Y} Appearance & Themes\n"
    printf "${C}[${W}04${C}]${B} Security\n"
    printf "${C}[${W}05${C}]${G} Apply Changes to .zshrc\n"
    printf "${C}[${W}00${C}]${R} Exit\n\n"

    echo -ne "${C}Selection: ${RS}"
    read -r a
    case $a in
        1|01) do_install_deps ;;
        2|02) zsh_menu ;;
        3|03) appearance_menu ;;
        4|04) security_menu ;;
        5|05)
            load_config
            apply_all
            press_enter
            menu
            ;;
        0|00)
            echo -e "\n${C}Goodbye, ${USERNAME}. Stay hacking. 🔐${RS}"
            echo -e "${Y}Run: source ~/.zshrc — to apply changes${RS}\n"
            exit 0
            ;;
        *) menu ;;
    esac
}

zsh_menu() {
    load_config
    banner

    printf "${C}[${W}01${C}]${G} Startup Banner Settings\n"
    printf "${C}[${W}02${C}]${G} Prompt Style\n"
    printf "${C}[${W}03${C}]${Y} Change Username\n"
    printf "${C}[${W}04${C}]${Y} Change Hostname\n"
    printf "${C}[${W}00${C}]${R} Back\n\n"

    echo -ne "${C}Selection: ${RS}"
    read -r a
    case $a in
        1|01) banner_menu ;;
        2|02) prompt_menu ;;
        3|03)
            echo -ne "\n${Y}New username (now: ${USERNAME}): ${RS}"
            read -r new_user
            [ -n "$new_user" ] && USERNAME="$new_user" && save_config
            apply_all
            press_enter
            zsh_menu
            ;;
        4|04)
            echo -ne "\n${Y}New hostname (now: ${HOSTNAME}): ${RS}"
            read -r new_host
            [ -n "$new_host" ] && HOSTNAME="$new_host" && save_config
            apply_all
            press_enter
            zsh_menu
            ;;
        0|00) menu ;;
        *) zsh_menu ;;
    esac
}

banner_menu() {
    load_config
    banner

    printf "${C}[${W}01${C}]${G} Type: Figlet + Lolcat"
    [ "$BANNER_TYPE" = "figlet" ] && printf " ${R}◀ active"
    printf "\n"
    printf "${C}[${W}02${C}]${G} Type: Neofetch"
    [ "$BANNER_TYPE" = "neofetch" ] && printf " ${R}◀ active"
    printf "\n"
    printf "${C}[${W}03${C}]${G} Type: Figlet + Neofetch"
    [ "$BANNER_TYPE" = "both" ] && printf " ${R}◀ active"
    printf "\n"
    printf "${C}[${W}04${C}]${Y} Change Banner Text (now: ${BANNER_TEXT})\n"
    printf "${C}[${W}05${C}]${Y} Color: Random/Lolcat"
    [ "$BANNER_COLOR" = "random" ] && printf " ${R}◀"
    printf "\n"
    printf "${C}[${W}06${C}]${Y} Color: Cyan"
    [ "$BANNER_COLOR" = "cyan" ] && printf " ${R}◀"
    printf "\n"
    printf "${C}[${W}07${C}]${Y} Color: Green"
    [ "$BANNER_COLOR" = "green" ] && printf " ${R}◀"
    printf "\n"
    printf "${C}[${W}08${C}]${Y} Color: Red"
    [ "$BANNER_COLOR" = "red" ] && printf " ${R}◀"
    printf "\n"
    printf "${C}[${W}09${C}]${R} Remove Startup Banner\n"
    printf "${C}[${W}00${C}]${R} Back\n\n"

    echo -ne "${C}Selection: ${RS}"
    read -r a
    case $a in
        1|01) BANNER_TYPE="figlet";   save_config; apply_all; press_enter; banner_menu ;;
        2|02) BANNER_TYPE="neofetch"; save_config; apply_all; press_enter; banner_menu ;;
        3|03) BANNER_TYPE="both";     save_config; apply_all; press_enter; banner_menu ;;
        4|04)
            echo -ne "\n${Y}Banner text: ${RS}"
            read -r new_text
            [ -n "$new_text" ] && BANNER_TEXT="$new_text" && save_config
            apply_all
            press_enter
            banner_menu
            ;;
        5|05) BANNER_COLOR="random";  save_config; apply_all; press_enter; banner_menu ;;
        6|06) BANNER_COLOR="cyan";    save_config; apply_all; press_enter; banner_menu ;;
        7|07) BANNER_COLOR="green";   save_config; apply_all; press_enter; banner_menu ;;
        8|08) BANNER_COLOR="red";     save_config; apply_all; press_enter; banner_menu ;;
        9|09)
            remove_block "BANNER"
            echo -e "${G}[✔] Startup banner removed${RS}"
            press_enter
            banner_menu
            ;;
        0|00) zsh_menu ;;
        *) banner_menu ;;
    esac
}

prompt_menu() {
    load_config
    banner

    printf "${C}[${W}01${C}]${G} Kali Style"
    [ "$PROMPT_STYLE" = "kali" ] && printf " ${R}◀ active"
    printf "\n${DIM}   ┌──(${USERNAME}@${HOSTNAME})-[~]\n   └─\$${RS}\n\n"

    printf "${C}[${W}02${C}]${G} Arrow Style"
    [ "$PROMPT_STYLE" = "arrow" ] && printf " ${R}◀ active"
    printf "\n${DIM}   ╔═[${USERNAME}@${HOSTNAME}]═[~]\n   ╚═▶${RS}\n\n"

    printf "${C}[${W}03${C}]${G} Minimal Style"
    [ "$PROMPT_STYLE" = "minimal" ] && printf " ${R}◀ active"
    printf "\n${DIM}   ${USERNAME}@${HOSTNAME} ~ ❯${RS}\n\n"

    printf "${C}[${W}04${C}]${G} Hacker Style"
    [ "$PROMPT_STYLE" = "hacker" ] && printf " ${R}◀ active"
    printf "\n${DIM}   [root@${HOSTNAME}]-[~]\n   #${RS}\n\n"

    printf "${C}[${W}05${C}]${G} Powerline Style"
    [ "$PROMPT_STYLE" = "powerline" ] && printf " ${R}◀ active"
    printf "\n${DIM}   ${USERNAME}  ${HOSTNAME}  ~ ▶${RS}\n\n"

    printf "${C}[${W}00${C}]${R} Back\n\n"

    echo -ne "${C}Selection: ${RS}"
    read -r a
    case $a in
        1|01) PROMPT_STYLE="kali";      save_config; apply_all; press_enter; prompt_menu ;;
        2|02) PROMPT_STYLE="arrow";     save_config; apply_all; press_enter; prompt_menu ;;
        3|03) PROMPT_STYLE="minimal";   save_config; apply_all; press_enter; prompt_menu ;;
        4|04) PROMPT_STYLE="hacker";    save_config; apply_all; press_enter; prompt_menu ;;
        5|05) PROMPT_STYLE="powerline"; save_config; apply_all; press_enter; prompt_menu ;;
        0|00) zsh_menu ;;
        *) prompt_menu ;;
    esac
}

appearance_menu() {
    load_config
    banner

    printf "${C}[${W}01${C}]${G} Install FiraCode Nerd Font\n"
    printf "${C}[${W}02${C}]${Y} Theme: Hacker Green\n"
    printf "${C}[${W}03${C}]${B} Theme: Kali Dark\n"
    printf "${C}[${W}04${C}]${M} Theme: Dracula\n"
    printf "${C}[${W}05${C}]${G} Theme: Matrix Black\n"
    printf "${C}[${W}06${C}]${M} Theme: Catppuccin\n"
    printf "${C}[${W}00${C}]${R} Back\n\n"

    echo -ne "${C}Selection: ${RS}"
    read -r a
    case $a in
        1|01) do_install_font ;;
        2|02) apply_color_theme "hacker";     press_enter; appearance_menu ;;
        3|03) apply_color_theme "kali";       press_enter; appearance_menu ;;
        4|04) apply_color_theme "dracula";    press_enter; appearance_menu ;;
        5|05) apply_color_theme "matrix";     press_enter; appearance_menu ;;
        6|06) apply_color_theme "catppuccin"; press_enter; appearance_menu ;;
        0|00) menu ;;
        *) appearance_menu ;;
    esac
}

security_menu() {
    load_config
    banner

    printf "${C}[${W}01${C}]${B} Add Terminal Lock\n"
    printf "${C}[${W}02${C}]${R} Remove Terminal Lock\n"
    printf "${C}[${W}00${C}]${R} Back\n\n"

    echo -ne "${C}Selection: ${RS}"
    read -r a
    case $a in
        1|01) do_add_lock    ;;
        2|02) do_remove_lock ;;
        0|00) menu ;;
        *) security_menu ;;
    esac
}

# ── Entry ─────────────────────────────────────
load_config
menu
