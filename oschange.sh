#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════╗
# ║   Ter-Chan OS — Termux Customization Tool v2.0              ║
# ║   Python Edition — No CRLF, No Shebang Issues              ║
# ╚══════════════════════════════════════════════════════════════╝

import os
import sys
import subprocess
import getpass

# ── Colors ────────────────────────────────────────────────────
R  = '\033[1;31m'
G  = '\033[1;32m'
Y  = '\033[1;33m'
B  = '\033[1;34m'
M  = '\033[1;35m'
C  = '\033[1;36m'
W  = '\033[1;37m'
DIM= '\033[2m'
RS = '\033[0m'

# ── Width ─────────────────────────────────────────────────────
TW  = 60
BW  = 56
PAD = (TW - BW) // 2
LP  = ' ' * PAD

# ── Config ────────────────────────────────────────────────────
HOME       = os.path.expanduser('~')
CONFIG     = os.path.join(HOME, '.tyranroot_config')
TERMUX_BIN = '/data/data/com.termux/files/usr/bin'

def load_config():
    cfg = {
        'USERNAME'    : 'TyranRoot',
        'HOSTNAME'    : 'Termux',
        'SHELL_COLOR' : 'cyan',
        'PROMPT_STYLE': 'kali',
        'BANNER_STYLE': '1',
    }
    if not os.path.exists(CONFIG):
        save_config(cfg)
    else:
        with open(CONFIG) as f:
            for line in f:
                line = line.strip()
                if '=' in line and not line.startswith('#'):
                    k, v = line.split('=', 1)
                    cfg[k.strip()] = v.strip()
    return cfg

def save_config(cfg):
    with open(CONFIG, 'w') as f:
        for k, v in cfg.items():
            f.write(f'{k}={v}\n')

cfg = load_config()

# ── Helpers ───────────────────────────────────────────────────
def cline(left, right):
    line = '═' * (BW - 2)
    print(f'{C}{LP}{left}{line}{right}{RS}')

def cmid(text, color=None):
    if color is None:
        color = W
    length = len(text)
    sp  = (BW - 2 - length) // 2
    sp2 = (BW - 2 - length) - sp
    sp  = max(sp,  0)
    sp2 = max(sp2, 0)
    print(f'{C}{LP}║{" " * sp}{color}{text}{C}{" " * sp2}║{RS}')

def press_enter():
    print(f'\n{LP}{DIM}Press Enter to continue...{RS}')
    input()

def run(cmd, shell=True):
    subprocess.run(cmd, shell=shell)

def pkg_install(*packages):
    run(f'pkg install -y {" ".join(packages)}')

def append_file(path, content):
    with open(path, 'a') as f:
        f.write(content)

def remove_block(path, start_marker, end_marker):
    if not os.path.exists(path):
        return
    with open(path) as f:
        lines = f.readlines()
    out    = []
    inside = False
    for line in lines:
        if start_marker in line:
            inside = True
        if not inside:
            out.append(line)
        if end_marker in line:
            inside = False
    with open(path, 'w') as f:
        f.writelines(out)

# ── Banner ────────────────────────────────────────────────────
def banner():
    os.system('clear')
    print()
    style = cfg.get('BANNER_STYLE', '1')

    if style == '1':
        print(f'{C}{LP}  ████████╗███████╗██████╗      ██████╗██╗  ██╗ █████╗ ███╗   ██╗{RS}')
        print(f'{C}{LP}     ██╔══╝██╔════╝██╔══██╗    ██╔════╝██║  ██║██╔══██╗████╗  ██║{RS}')
        print(f'{G}{LP}     ██║   █████╗  ██████╔╝    ██║     ███████║███████║██╔██╗ ██║{RS}')
        print(f'{G}{LP}     ██║   ██╔══╝  ██╔══██╗    ██║     ██╔══██║██╔══██║██║╚██╗██║{RS}')
        print(f'{R}{LP}     ██║   ███████╗██║  ██║    ╚██████╗██║  ██║██║  ██║██║ ╚████║{RS}')
        print(f'{R}{LP}     ╚═╝   ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝{RS}')
    elif style == '2':
        print(f'{C}{LP} _______ _____ ____      ____ _   _    _    _   _ ')
        print(f'{C}{LP}|__   __|  ___|  _ \\    / ___| | | |  / \\  | \\ | |')
        print(f'{G}{LP}   | |  | |_  | |_) |  | |   | |_| | / _ \\ |  \\| |')
        print(f'{G}{LP}   | |  |  _| |  _ <   | |___|  _  |/ ___ \\| |\\  |')
        print(f'{R}{LP}   |_|  |___| |_| \\_\\   \\____|_| |_/_/   \\_\\_| \\_|{RS}')
        print(f'{R}{LP}         TER-CHAN OS v2.0{RS}')
    elif style == '3':
        figlet = os.path.join(TERMUX_BIN, 'figlet')
        if os.path.exists(figlet):
            result = subprocess.run([figlet, 'Ter-Chan'], capture_output=True, text=True)
            for line in result.stdout.splitlines():
                print(f'{C}{LP}{line}{RS}')
        else:
            print(f'{C}{LP}  Ter-Chan OS{RS}')

    print()
    cline('╔', '╗')
    cmid('Ter-Chan OS — Termux Customization v2.0', W)
    cmid('Fully Optimized for Termux', DIM)
    cline('╚', '╝')
    print()
    print(f'{LP}  {R}[!]{W} User     : {C}{cfg.get("USERNAME","TyranRoot")}{RS}')
    print(f'{LP}  {R}[!]{W} Host     : {C}{cfg.get("HOSTNAME","Termux")}{RS}')
    print(f'{LP}  {R}[!]{W} Shell    : {C}{os.path.basename(os.environ.get("SHELL","bash"))}{RS}')
    print(f'{LP}  {R}[!]{W} Prompt   : {C}{cfg.get("PROMPT_STYLE","kali")}{RS}')
    print()

# ── Install Base ──────────────────────────────────────────────
def install_base():
    print(f'\n{LP}{Y}[▶] Installing base packages...{RS}\n')
    run('pkg update -y && pkg upgrade -y')
    pkg_install('zsh', 'fish', 'git', 'curl', 'wget', 'figlet',
                'toilet', 'ruby', 'bat', 'eza', 'lsd', 'neofetch')
    run('gem install lolcat 2>/dev/null || true')
    print(f'\n{LP}{G}[✔] Base packages installed.{RS}')
    press_enter()
    menu()

# ── Prompt helpers ────────────────────────────────────────────
def apply_zsh_prompt(style):
    user = cfg.get('USERNAME', 'TyranRoot')
    host = cfg.get('HOSTNAME', 'Termux')
    rc   = os.path.join(HOME, '.zshrc')
    remove_block(rc, '# TyranRoot', '')

    prompts = {
        'kali': f"""
# TyranRoot Kali-style prompt
autoload -Uz vcs_info
precmd() {{ vcs_info }}
zstyle ':vcs_info:git:*' formats '(%b)'
setopt PROMPT_SUBST
PROMPT='%F{{red}}┌──(%F{{cyan}}{user}@{host}%F{{red}})-[%F{{white}}%~%F{{red}}]%f$(vcs_info_msg_0_)
%F{{red}}└─%F{{white}}$ %f'
""",
        'arrow': f"""
# TyranRoot Arrow prompt
PROMPT='%F{{cyan}}╔═[%F{{white}}{user}@{host}%F{{cyan}}]═[%F{{green}}%~%F{{cyan}}]
%F{{cyan}}╚═▶ %F{{white}}%f'
""",
        'minimal': f"""
# TyranRoot Minimal prompt
PROMPT='%F{{cyan}}{user}%F{{white}}@%F{{red}}{host} %F{{green}}%~ %F{{yellow}}❯ %f'
""",
        'hacker': f"""
# TyranRoot Hacker prompt
PROMPT='%F{{green}}[%F{{white}}root@{host}%F{{green}}]-[%F{{red}}%~%F{{green}}]
%F{{green}}# %f'
""",
        'powerline': f"""
# TyranRoot Powerline prompt
PROMPT='%K{{blue}}%F{{white}} {user} %k%K{{cyan}}%F{{blue}}%F{{black}} {host} %k%K{{green}}%F{{cyan}}%F{{black}} %~ %k%F{{green}} %f'
""",
    }
    if style in prompts:
        append_file(rc, prompts[style])
    print(f'{LP}{G}[✔] Zsh prompt applied: {style}{RS}')

def apply_fish_prompt(style):
    user = cfg.get('USERNAME', 'TyranRoot')
    host = cfg.get('HOSTNAME', 'Termux')
    fish_dir = os.path.join(HOME, '.config', 'fish', 'functions')
    os.makedirs(fish_dir, exist_ok=True)
    fish_file = os.path.join(fish_dir, 'fish_prompt.fish')

    prompts = {
        'kali': f"""function fish_prompt
    set_color red
    echo -n "┌──("
    set_color cyan
    echo -n "{user}@{host}"
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
    echo -n "$ "
    set_color normal
end
""",
        'arrow': f"""function fish_prompt
    set_color cyan
    echo -n "╔═["
    set_color white
    echo -n "{user}@{host}"
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
""",
        'hacker': f"""function fish_prompt
    set_color green
    echo -n "[root@{host}]-["
    set_color red
    echo -n (prompt_pwd)
    set_color green
    echo -n "]"
    echo
    echo -n "# "
    set_color normal
end
""",
        'minimal': f"""function fish_prompt
    set_color cyan
    echo -n "{user}"
    set_color white
    echo -n "@"
    set_color red
    echo -n "{host}"
    set_color green
    echo -n " "(prompt_pwd)
    set_color yellow
    echo -n " ❯ "
    set_color normal
end
""",
    }
    if style in prompts:
        with open(fish_file, 'w') as f:
            f.write(prompts[style])
    print(f'{LP}{G}[✔] Fish prompt applied: {style}{RS}')

def apply_bash_prompt(style):
    user = cfg.get('USERNAME', 'TyranRoot')
    host = cfg.get('HOSTNAME', 'Termux')
    rc   = os.path.join(HOME, '.bashrc')
    remove_block(rc, '# TyranRoot prompt', '')

    prompts = {
        'kali'    : f"\n# TyranRoot prompt\nPS1='\\[\\033[1;31m\\]┌──(\\[\\033[1;36m\\]{user}@{host}\\[\\033[1;31m\\])-[\\[\\033[1;37m\\]\\w\\[\\033[1;31m\\]]\\n└─\\[\\033[1;37m\\]\\$ \\[\\033[0m\\]'\n",
        'hacker'  : f"\n# TyranRoot prompt\nPS1='\\[\\033[1;32m\\][root@{host}]-[\\[\\033[1;31m\\]\\w\\[\\033[1;32m\\]]\\n# \\[\\033[0m\\]'\n",
        'arrow'   : f"\n# TyranRoot prompt\nPS1='\\[\\033[1;36m\\]╔═[\\[\\033[1;37m\\]{user}@{host}\\[\\033[1;36m\\]]═[\\[\\033[1;32m\\]\\w\\[\\033[1;36m\\]]\\n╚═▶ \\[\\033[0m\\]'\n",
        'minimal' : f"\n# TyranRoot prompt\nPS1='\\[\\033[1;36m\\]{user}\\[\\033[1;37m\\]@\\[\\033[1;31m\\]{host} \\[\\033[1;32m\\]\\w \\[\\033[1;33m\\]❯ \\[\\033[0m\\]'\n",
    }
    if style in prompts:
        append_file(rc, prompts[style])
    print(f'{LP}{G}[✔] Bash prompt applied: {style}{RS}')

# ── Change Shell ──────────────────────────────────────────────
def change_shell(shell):
    paths = {
        'zsh' : os.path.join(TERMUX_BIN, 'zsh'),
        'fish': os.path.join(TERMUX_BIN, 'fish'),
        'bash': os.path.join(TERMUX_BIN, 'bash'),
    }
    shell_path = paths.get(shell, '')
    if os.path.exists(shell_path):
        termux_dir = os.path.join(HOME, '.termux')
        os.makedirs(termux_dir, exist_ok=True)
        with open(os.path.join(termux_dir, 'shell'), 'w') as f:
            f.write(shell_path + '\n')
        run('termux-reload-settings 2>/dev/null || true')
        print(f'{LP}{G}[✔] Shell set to {shell}. Restart Termux to apply.{RS}')
    else:
        print(f'{LP}{R}[✘] {shell} not installed. Install first.{RS}')

# ── Zsh Plugins ───────────────────────────────────────────────
def install_zsh_plugins():
    print(f'\n{LP}{Y}[▶] Installing Zsh plugins...{RS}\n')
    omz = os.path.join(HOME, '.oh-my-zsh')
    if not os.path.exists(omz):
        run(f'git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git {omz}')
        zshrc = os.path.join(HOME, '.zshrc')
        if not os.path.exists(zshrc):
            run(f'cp {omz}/templates/zshrc.zsh-template {zshrc}')

    custom = os.environ.get('ZSH_CUSTOM', os.path.join(omz, 'custom'))
    hl = os.path.join(custom, 'plugins', 'zsh-syntax-highlighting')
    if not os.path.exists(hl):
        run(f'git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git {hl}')
    as_ = os.path.join(custom, 'plugins', 'zsh-autosuggestions')
    if not os.path.exists(as_):
        run(f'git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git {as_}')

    zshrc = os.path.join(HOME, '.zshrc')
    if os.path.exists(zshrc):
        run(f"sed -i 's/^plugins=.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' {zshrc}")

    print(f'{LP}{G}[✔] Plugins installed: syntax-highlighting, autosuggestions{RS}')
    press_enter()
    zsh_menu()

# ── Nerd Font ─────────────────────────────────────────────────
def install_font():
    print(f'\n{LP}{Y}[▶] Installing FiraCode Nerd Font...{RS}\n')
    termux_dir = os.path.join(HOME, '.termux')
    os.makedirs(termux_dir, exist_ok=True)
    url = 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf'
    result = run(f'curl -fL "{url}" -o {termux_dir}/font.ttf')
    if result is None:
        print(f'{LP}{G}[✔] Font installed. Restart Termux to apply.{RS}')
    run('termux-reload-settings 2>/dev/null || true')
    press_enter()
    appearance_menu()

# ── Color Theme ───────────────────────────────────────────────
THEMES = {
    'hacker': """background=#020c06
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
""",
    'kali': """background=#1a1a2e
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
""",
    'dracula': """background=#282a36
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
""",
    'matrix': """background=#000000
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
""",
}

def apply_color_theme(theme):
    if theme not in THEMES:
        return
    termux_dir = os.path.join(HOME, '.termux')
    os.makedirs(termux_dir, exist_ok=True)
    with open(os.path.join(termux_dir, 'colors.properties'), 'w') as f:
        f.write(THEMES[theme])
    run('termux-reload-settings 2>/dev/null || true')
    print(f'{LP}{G}[✔] Theme applied: {theme}{RS}')

# ── Identity ──────────────────────────────────────────────────
def change_identity():
    print(f'\n{LP}{C}Current: {W}{cfg.get("USERNAME","TyranRoot")}@{cfg.get("HOSTNAME","Termux")}{RS}')
    new_user = input(f'{LP}{Y}New username (Enter to keep): {RS}').strip()
    new_host = input(f'{LP}{Y}New hostname (Enter to keep): {RS}').strip()
    if new_user:
        cfg['USERNAME'] = new_user
    if new_host:
        cfg['HOSTNAME'] = new_host
    save_config(cfg)
    print(f'{LP}{G}[✔] Identity updated: {cfg["USERNAME"]}@{cfg["HOSTNAME"]}{RS}')
    press_enter()
    identity_menu()

# ── Security Lock ─────────────────────────────────────────────
def do_add_lock():
    print(f'\n{LP}{C}[▶] Setting up terminal security lock...{RS}')
    new_pass = getpass.getpass(f'{LP}{Y}Create Access Key: {RS}')
    lock_code = f"""
#TYRANLOCK_START
clear
echo -e '\\033[1;32m  Initializing...\\033[0m'
sleep 0.3
clear
_tl_attempt=1
while [ $_tl_attempt -le 3 ]; do
    echo -e "\\n\\033[1;36m╔══════════════════════════════════════╗"
    echo -e "║  \\033[1;31m⬡ TYRANROOT — SECURE ACCESS \\033[1;36m        ║"
    echo -e "╚══════════════════════════════════════╝\\033[0m"
    echo -ne "\\033[1;33m  [Attempt $_tl_attempt/3] Access Key: \\033[0m"
    read -rs _tl_pass
    echo
    if [ "$_tl_pass" = "{new_pass}" ]; then
        echo -e "\\033[1;32m  ✔ ACCESS GRANTED\\033[0m"
        sleep 0.8
        clear
        break
    else
        echo -e "\\033[1;31m  ✘ DENIED\\033[0m"
        if [ $_tl_attempt -eq 3 ]; then
            exit 1
        fi
        _tl_attempt=$((_tl_attempt+1))
        sleep 0.5
    fi
done
#TYRANLOCK_END
"""
    bashrc = os.path.join(HOME, '.bashrc')
    append_file(bashrc, lock_code)
    print(f'{LP}{G}[✔] Security lock added.{RS}')
    press_enter()
    security_menu()

def do_remove_lock():
    for rc in ['.bashrc', '.zshrc', '.config/fish/config.fish']:
        path = os.path.join(HOME, rc)
        remove_block(path, '#TYRANLOCK_START', '#TYRANLOCK_END')
    print(f'{LP}{G}[✔] Security lock removed.{RS}')
    press_enter()
    security_menu()

# ── MOTD ──────────────────────────────────────────────────────
def setup_motd(choice):
    motd = '/data/data/com.termux/files/usr/etc/motd'
    if os.path.exists(motd):
        try:
            os.remove(motd)
        except:
            pass

    if choice == 'neofetch':
        pkg_install('neofetch')
        for rc in ['.bashrc', '.zshrc']:
            path = os.path.join(HOME, rc)
            if os.path.exists(path):
                with open(path) as f:
                    content = f.read()
                if 'neofetch' not in content:
                    append_file(path, '\n# TyranRoot MOTD\nneofetch\n')
        print(f'{LP}{G}[✔] Neofetch set as startup banner.{RS}')

    elif choice == 'custom':
        cmd = 'echo -e "\\033[1;36m"; figlet "Ter-Chan" 2>/dev/null; echo -e "\\033[1;32m  Termux OS v2.0 | Ter-Chan\\033[0m\\n"'
        for rc in ['.bashrc', '.zshrc']:
            path = os.path.join(HOME, rc)
            if not os.path.exists(path):
                continue
            with open(path) as f:
                content = f.read()
            if 'TyranRoot MOTD' not in content:
                append_file(path, f'\n# TyranRoot MOTD\n{cmd}\n')
        print(f'{LP}{G}[✔] Custom ASCII banner set as startup.{RS}')

    elif choice == 'remove':
        for rc in ['.bashrc', '.zshrc']:
            path = os.path.join(HOME, rc)
            if os.path.exists(path):
                with open(path) as f:
                    lines = f.readlines()
                out = []
                skip_next = False
                for line in lines:
                    if '# TyranRoot MOTD' in line:
                        skip_next = True
                        continue
                    if skip_next:
                        skip_next = False
                        continue
                    out.append(line)
                with open(path, 'w') as f:
                    f.writelines(out)
        print(f'{LP}{G}[✔] Startup banner removed.{RS}')

    press_enter()
    appearance_menu()

# ══════════════════════════════════════════
#  MENUS
# ══════════════════════════════════════════
def menu():
    banner()
    cline('╔', '╗')
    cmid('MAIN MENU', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} 📦 Install Base Packages')
    print(f'{LP}  {C}[{W}02{C}]{G} 🐚 Zsh Options')
    print(f'{LP}  {C}[{W}03{C}]{G} 🐟 Fish Options')
    print(f'{LP}  {C}[{W}04{C}]{G} 💻 Bash Options')
    print(f'{LP}  {C}[{W}05{C}]{Y} 🎨 Appearance & Themes')
    print(f'{LP}  {C}[{W}06{C}]{M} 👤 Identity')
    print(f'{LP}  {C}[{W}07{C}]{B} 🔒 Security')
    print(f'{LP}  {C}[{W}00{C}]{R} ✖  Exit')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if   a in ('1','01'): install_base()
    elif a in ('2','02'): zsh_menu()
    elif a in ('3','03'): fish_menu()
    elif a in ('4','04'): bash_menu()
    elif a in ('5','05'): appearance_menu()
    elif a in ('6','06'): identity_menu()
    elif a in ('7','07'): security_menu()
    elif a in ('0','00'):
        print(f'\n{LP}{C}Goodbye, {cfg.get("USERNAME","TyranRoot")}. Stay hacking. 🔐{RS}\n')
        sys.exit(0)
    else:
        menu()

def zsh_menu():
    banner()
    cline('╔', '╗')
    cmid('ZSH OPTIONS', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Install Oh-My-Zsh')
    print(f'{LP}  {C}[{W}02{C}]{G} Switch to Zsh')
    print(f'{LP}  {C}[{W}03{C}]{Y} Install Plugins')
    print(f'{LP}  {C}[{W}04{C}]{Y} Apply Prompt Style')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if a in ('1','01'):
        omz = os.path.join(HOME, '.oh-my-zsh')
        print(f'\n{LP}{Y}Installing Oh-My-Zsh...{RS}')
        if not os.path.exists(omz):
            run(f'git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git {omz}')
        zshrc = os.path.join(HOME, '.zshrc')
        if not os.path.exists(zshrc):
            run(f'cp {omz}/templates/zshrc.zsh-template {zshrc}')
        print(f'{LP}{G}[✔] Done.{RS}')
        press_enter()
        zsh_menu()
    elif a in ('2','02'):
        change_shell('zsh')
        press_enter()
        zsh_menu()
    elif a in ('3','03'): install_zsh_plugins()
    elif a in ('4','04'): prompt_style_menu('zsh')
    elif a in ('0','00'): menu()
    else: zsh_menu()

def fish_menu():
    banner()
    cline('╔', '╗')
    cmid('FISH OPTIONS', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Install Fish')
    print(f'{LP}  {C}[{W}02{C}]{G} Switch to Fish')
    print(f'{LP}  {C}[{W}03{C}]{Y} Apply Prompt Style')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if a in ('1','01'):
        pkg_install('fish')
        print(f'{LP}{G}[✔] Fish installed.{RS}')
        press_enter()
        fish_menu()
    elif a in ('2','02'):
        change_shell('fish')
        press_enter()
        fish_menu()
    elif a in ('3','03'): prompt_style_menu('fish')
    elif a in ('0','00'): menu()
    else: fish_menu()

def bash_menu():
    banner()
    cline('╔', '╗')
    cmid('BASH OPTIONS', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Switch to Bash')
    print(f'{LP}  {C}[{W}02{C}]{Y} Apply Prompt Style')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if a in ('1','01'):
        change_shell('bash')
        press_enter()
        bash_menu()
    elif a in ('2','02'): prompt_style_menu('bash')
    elif a in ('0','00'): menu()
    else: bash_menu()

def prompt_style_menu(shell):
    banner()
    cline('╔', '╗')
    cmid(f'PROMPT STYLE — {shell.upper()}', C)
    cline('╚', '╝')
    user = cfg.get('USERNAME', 'TyranRoot')
    host = cfg.get('HOSTNAME', 'Termux')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Kali Linux Style')
    print(f'{LP}  {DIM}       ┌──({user}@{host})-[~]')
    print(f'{LP}       └─${RS}')
    print()
    print(f'{LP}  {C}[{W}02{C}]{G} Arrow Style')
    print(f'{LP}  {DIM}       ╔═[{user}@{host}]═[~]')
    print(f'{LP}       ╚═▶ {RS}')
    print()
    print(f'{LP}  {C}[{W}03{C}]{G} Minimal Style')
    print(f'{LP}  {DIM}       {user}@{host} ~ ❯ {RS}')
    print()
    print(f'{LP}  {C}[{W}04{C}]{G} Hacker Style')
    print(f'{LP}  {DIM}       [root@{host}]-[~]')
    print(f'{LP}       # {RS}')
    print()
    if shell == 'zsh':
        print(f'{LP}  {C}[{W}05{C}]{G} Powerline Style')
        print()
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    style_map = {'1':'kali','01':'kali','2':'arrow','02':'arrow',
                 '3':'minimal','03':'minimal','4':'hacker','04':'hacker',
                 '5':'powerline','05':'powerline'}

    if a in ('0','00'):
        if shell == 'zsh': zsh_menu()
        elif shell == 'fish': fish_menu()
        else: bash_menu()
        return

    style = style_map.get(a)
    if style:
        if shell == 'zsh':   apply_zsh_prompt(style)
        elif shell == 'fish': apply_fish_prompt(style)
        else:                 apply_bash_prompt(style)
        cfg['PROMPT_STYLE'] = style
        save_config(cfg)
        print(f'{LP}{Y}[!] Restart shell or run: source ~/.{shell}rc{RS}')
        press_enter()

    if shell == 'zsh': zsh_menu()
    elif shell == 'fish': fish_menu()
    else: bash_menu()

def appearance_menu():
    banner()
    cline('╔', '╗')
    cmid('APPEARANCE & THEMES', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Install FiraCode Nerd Font')
    print(f'{LP}  {C}[{W}02{C}]{Y} Color Theme: Hacker Green')
    print(f'{LP}  {C}[{W}03{C}]{B} Color Theme: Kali Dark')
    print(f'{LP}  {C}[{W}04{C}]{M} Color Theme: Dracula')
    print(f'{LP}  {C}[{W}05{C}]{G} Color Theme: Matrix Black')
    print(f'{LP}  {C}[{W}06{C}]{W} Startup Banner: Neofetch')
    print(f'{LP}  {C}[{W}07{C}]{W} Startup Banner: Custom ASCII')
    print(f'{LP}  {C}[{W}08{C}]{R} Remove Startup Banner')
    print(f'{LP}  {C}[{W}09{C}]{Y} Change Banner Style')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if   a in ('1','01'): install_font()
    elif a in ('2','02'):
        apply_color_theme('hacker'); press_enter(); appearance_menu()
    elif a in ('3','03'):
        apply_color_theme('kali'); press_enter(); appearance_menu()
    elif a in ('4','04'):
        apply_color_theme('dracula'); press_enter(); appearance_menu()
    elif a in ('5','05'):
        apply_color_theme('matrix'); press_enter(); appearance_menu()
    elif a in ('6','06'): setup_motd('neofetch')
    elif a in ('7','07'): setup_motd('custom')
    elif a in ('8','08'): setup_motd('remove')
    elif a in ('9','09'): banner_style_menu()
    elif a in ('0','00'): menu()
    else: appearance_menu()

def banner_style_menu():
    banner()
    cline('╔', '╗')
    cmid('BANNER STYLE', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Style 1 — Block Unicode')
    print(f'{LP}  {C}[{W}02{C}]{G} Style 2 — Compact ASCII')
    print(f'{LP}  {C}[{W}03{C}]{G} Style 3 — Figlet')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if a in ('1','01'):
        cfg['BANNER_STYLE'] = '1'; save_config(cfg); appearance_menu()
    elif a in ('2','02'):
        cfg['BANNER_STYLE'] = '2'; save_config(cfg); appearance_menu()
    elif a in ('3','03'):
        cfg['BANNER_STYLE'] = '3'; save_config(cfg); appearance_menu()
    elif a in ('0','00'): appearance_menu()
    else: banner_style_menu()

def identity_menu():
    banner()
    cline('╔', '╗')
    cmid('IDENTITY SETTINGS', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Change Username & Hostname')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    print(f'{LP}  {DIM}Current: {cfg.get("USERNAME","TyranRoot")}@{cfg.get("HOSTNAME","Termux")}{RS}')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if   a in ('1','01'): change_identity()
    elif a in ('0','00'): menu()
    else: identity_menu()

def security_menu():
    banner()
    cline('╔', '╗')
    cmid('SECURITY', C)
    cline('╚', '╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{B} Add Terminal Lock')
    print(f'{LP}  {C}[{W}02{C}]{R} Remove Terminal Lock')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if   a in ('1','01'): do_add_lock()
    elif a in ('2','02'): do_remove_lock()
    elif a in ('0','00'): menu()
    else: security_menu()

# ── Entry Point ───────────────────────────────────────────────
if __name__ == '__main__':
    try:
        menu()
    except KeyboardInterrupt:
        print(f'\n\n{LP}{C}Goodbye. Stay hacking. 🔐{RS}\n')
        sys.exit(0)
