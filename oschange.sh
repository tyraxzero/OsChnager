#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════════╗
# ║   Ter-Chan — Termux Customization Tool v3.0                 ║
# ║   Python Edition | Zsh Focused                              ║
# ╚══════════════════════════════════════════════════════════════╝

import os, sys, subprocess, getpass, shutil

# ── Colors ────────────────────────────────────────────────────
R  = '\033[1;31m'; G  = '\033[1;32m'; Y  = '\033[1;33m'
B  = '\033[1;34m'; M  = '\033[1;35m'; C  = '\033[1;36m'
W  = '\033[1;37m'; DIM= '\033[2m';    RS = '\033[0m'

TW=60; BW=56; PAD=(TW-BW)//2; LP=' '*PAD
HOME = os.path.expanduser('~')
CONFIG = os.path.join(HOME, '.terchan_config')
ZSHRC  = os.path.join(HOME, '.zshrc')
TERMUX_BIN = '/data/data/com.termux/files/usr/bin'

# ── Config ────────────────────────────────────────────────────
def load_config():
    cfg = {
        'USERNAME'    : 'TyranRoot',
        'HOSTNAME'    : 'Termux',
        'PROMPT_STYLE': 'kali',
        'BANNER_TYPE' : 'figlet',
        'BANNER_TEXT' : 'Ter-Chan',
        'BANNER_COLOR': 'random',
    }
    if os.path.exists(CONFIG):
        with open(CONFIG) as f:
            for line in f:
                line = line.strip()
                if '=' in line and not line.startswith('#'):
                    k, v = line.split('=', 1)
                    cfg[k.strip()] = v.strip()
    else:
        save_config(cfg)
    return cfg

def save_config(cfg):
    with open(CONFIG, 'w') as f:
        for k, v in cfg.items():
            f.write(f'{k}={v}\n')

cfg = load_config()

# ── Helpers ───────────────────────────────────────────────────
def cline(l, r):
    print(f'{C}{LP}{l}{"═"*(BW-2)}{r}{RS}')

def cmid(text, color=W):
    ln = len(text); sp=(BW-2-ln)//2; sp2=(BW-2-ln)-sp
    sp=max(sp,0); sp2=max(sp2,0)
    print(f'{C}{LP}║{" "*sp}{color}{text}{C}{" "*sp2}║{RS}')

def press_enter():
    print(f'\n{LP}{DIM}Press Enter to continue...{RS}')
    input()

def run(cmd):
    subprocess.run(cmd, shell=True)

def pkg_install(*pkgs):
    run(f'pkg install -y {" ".join(pkgs)}')

def cmd_exists(cmd):
    return shutil.which(cmd) is not None or \
           os.path.exists(os.path.join(TERMUX_BIN, cmd))

# ── Remove block from zshrc ───────────────────────────────────
def remove_block(path, marker):
    if not os.path.exists(path):
        return
    with open(path) as f:
        content = f.read()
    start = f'# >>>TERCHAN:{marker}:START'
    end   = f'# >>>TERCHAN:{marker}:END'
    while start in content and end in content:
        s = content.index(start)
        e = content.index(end) + len(end)
        content = content[:s] + content[e:]
    content = '\n'.join(
        line for line in content.splitlines()
        if line.strip() != ''
    ) + '\n'
    with open(path, 'w') as f:
        f.write(content)

def write_block(path, marker, block):
    remove_block(path, marker)
    with open(path, 'a') as f:
        f.write(f'\n# >>>TERCHAN:{marker}:START\n')
        f.write(block)
        f.write(f'\n# >>>TERCHAN:{marker}:END\n')

# ── Apply everything to .zshrc ────────────────────────────────
def apply_all():
    """Write banner + prompt block into .zshrc cleanly."""
    user  = cfg.get('USERNAME', 'TyranRoot')
    host  = cfg.get('HOSTNAME', 'Termux')
    style = cfg.get('PROMPT_STYLE', 'kali')
    btype = cfg.get('BANNER_TYPE', 'figlet')
    btext = cfg.get('BANNER_TEXT', 'Ter-Chan')
    bclr  = cfg.get('BANNER_COLOR', 'random')

    # ── Banner block ─────────────────────────────────────────
    if btype == 'figlet':
        if bclr == 'random':
            banner_cmd = f'figlet -f slant "{btext}" | lolcat'
        else:
            color_map = {
                'red':'\\033[1;31m','green':'\\033[1;32m',
                'cyan':'\\033[1;36m','yellow':'\\033[1;33m',
                'blue':'\\033[1;34m','magenta':'\\033[1;35m',
            }
            clr = color_map.get(bclr, '\\033[1;36m')
            banner_cmd = f'echo -e "{clr}"; figlet -f slant "{btext}"; echo -e "\\033[0m"'
    elif btype == 'neofetch':
        banner_cmd = 'neofetch'
    elif btype == 'both':
        if bclr == 'random':
            banner_cmd = f'figlet -f slant "{btext}" | lolcat\nneofetch'
        else:
            banner_cmd = f'figlet -f slant "{btext}" | lolcat\nneofetch'

    banner_block = banner_cmd + '\n'
    write_block(ZSHRC, 'BANNER', banner_block)

    # ── Prompt block ─────────────────────────────────────────
    prompts = {
        'kali': f"""autoload -Uz vcs_info
precmd() {{ vcs_info }}
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{{red}}┌──(%F{{cyan}}{user}%F{{white}}@%F{{green}}{host}%F{{red}})-[%F{{white}}%~%F{{red}}]%F{{yellow}}${{vcs_info_msg_0_}}%F{{red}}
└─%F{{white}}$ %f'
""",
        'arrow': f"""setopt PROMPT_SUBST
PROMPT='%F{{cyan}}╔═[%F{{white}}{user}%F{{cyan}}@%F{{green}}{host}%F{{cyan}}]═[%F{{yellow}}%~%F{{cyan}}]
%F{{cyan}}╚═▶ %F{{white}}%f'
""",
        'minimal': f"""setopt PROMPT_SUBST
PROMPT='%F{{cyan}}{user}%F{{white}}@%F{{red}}{host} %F{{green}}%~ %F{{yellow}}❯ %f'
""",
        'hacker': f"""setopt PROMPT_SUBST
PROMPT='%F{{green}}[%F{{white}}root@{host}%F{{green}}]-[%F{{red}}%~%F{{green}}]
%F{{green}}# %f'
""",
        'powerline': f"""setopt PROMPT_SUBST
PROMPT='%K{{blue}}%F{{white}} {user} %k%K{{cyan}}%F{{black}} {host} %k%K{{green}}%F{{black}} %~ %k%F{{green}}▶%f '
""",
    }
    prompt_block = prompts.get(style, prompts['kali'])
    write_block(ZSHRC, 'PROMPT', prompt_block)

    print(f'{LP}{G}[✔] .zshrc updated successfully!{RS}')
    print(f'{LP}{Y}[!] Run: source ~/.zshrc  — or restart Termux{RS}')

# ── Auto Install Dependencies ─────────────────────────────────
def install_deps():
    print(f'\n{LP}{Y}[▶] Checking & installing dependencies...{RS}\n')
    run('pkg update -y')
    to_install = []
    for pkg in ['zsh','git','curl','figlet','lolcat','neofetch',
                'ruby','toilet']:
        if not cmd_exists(pkg):
            to_install.append(pkg)
    if to_install:
        pkg_install(*to_install)
    # lolcat via gem if not found
    if not cmd_exists('lolcat'):
        run('gem install lolcat 2>/dev/null || true')
    # zsh plugins
    omz = os.path.join(HOME, '.oh-my-zsh')
    if not os.path.exists(omz):
        print(f'{LP}{Y}[▶] Installing Oh-My-Zsh...{RS}')
        run(f'git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git {omz}')
        if not os.path.exists(ZSHRC):
            run(f'cp {omz}/templates/zshrc.zsh-template {ZSHRC}')
    custom = os.path.join(omz, 'custom')
    hl = os.path.join(custom,'plugins','zsh-syntax-highlighting')
    if not os.path.exists(hl):
        print(f'{LP}{Y}[▶] Installing zsh-syntax-highlighting...{RS}')
        run(f'git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git {hl}')
    as_ = os.path.join(custom,'plugins','zsh-autosuggestions')
    if not os.path.exists(as_):
        print(f'{LP}{Y}[▶] Installing zsh-autosuggestions...{RS}')
        run(f'git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git {as_}')
    # enable plugins in .zshrc
    if os.path.exists(ZSHRC):
        run(f"sed -i 's/^plugins=.*/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' {ZSHRC}")
    # set zsh as default shell
    zsh_path = os.path.join(TERMUX_BIN, 'zsh')
    if os.path.exists(zsh_path):
        termux_dir = os.path.join(HOME, '.termux')
        os.makedirs(termux_dir, exist_ok=True)
        with open(os.path.join(termux_dir,'shell'),'w') as f:
            f.write(zsh_path+'\n')
        run('termux-reload-settings 2>/dev/null || true')
    print(f'\n{LP}{G}[✔] All dependencies installed!{RS}')
    press_enter()
    menu()

# ── Install Nerd Font ─────────────────────────────────────────
def install_font():
    print(f'\n{LP}{Y}[▶] Installing FiraCode Nerd Font...{RS}\n')
    termux_dir = os.path.join(HOME,'.termux')
    os.makedirs(termux_dir, exist_ok=True)
    url = 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf'
    run(f'curl -fL "{url}" -o {termux_dir}/font.ttf')
    run('termux-reload-settings 2>/dev/null || true')
    print(f'{LP}{G}[✔] Font installed. Restart Termux to apply.{RS}')
    press_enter()
    appearance_menu()

# ── Color Themes ──────────────────────────────────────────────
THEMES = {
    'hacker' : 'background=#020c06\nforeground=#00ff41\ncursor=#00ff41\ncolor0=#020c06\ncolor1=#ff2244\ncolor2=#00ff41\ncolor3=#ffcc00\ncolor4=#00ccff\ncolor5=#cc00ff\ncolor6=#00ffcc\ncolor7=#b0ffb0\ncolor8=#1a3a22\ncolor9=#ff4466\ncolor10=#33ff66\ncolor11=#ffdd44\ncolor12=#33ddff\ncolor13=#dd33ff\ncolor14=#33ffdd\ncolor15=#e0ffe0\n',
    'kali'   : 'background=#1a1a2e\nforeground=#e0e0e0\ncursor=#00d4ff\ncolor0=#1a1a2e\ncolor1=#ff4444\ncolor2=#44ff88\ncolor3=#ffcc00\ncolor4=#4488ff\ncolor5=#cc44ff\ncolor6=#44ffcc\ncolor7=#e0e0e0\ncolor8=#2a2a4e\ncolor9=#ff6666\ncolor10=#66ffaa\ncolor11=#ffdd44\ncolor12=#66aaff\ncolor13=#dd66ff\ncolor14=#66ffdd\ncolor15=#ffffff\n',
    'dracula' : 'background=#282a36\nforeground=#f8f8f2\ncursor=#f8f8f2\ncolor0=#21222c\ncolor1=#ff5555\ncolor2=#50fa7b\ncolor3=#f1fa8c\ncolor4=#bd93f9\ncolor5=#ff79c6\ncolor6=#8be9fd\ncolor7=#f8f8f2\ncolor8=#6272a4\ncolor9=#ff6e6e\ncolor10=#69ff94\ncolor11=#ffffa5\ncolor12=#d6acff\ncolor13=#ff92df\ncolor14=#a4ffff\ncolor15=#ffffff\n',
    'matrix'  : 'background=#000000\nforeground=#00ff00\ncursor=#00ff00\ncolor0=#000000\ncolor1=#003300\ncolor2=#00ff00\ncolor3=#009900\ncolor4=#006600\ncolor5=#00cc00\ncolor6=#33ff33\ncolor7=#00ff00\ncolor8=#002200\ncolor9=#004400\ncolor10=#00dd00\ncolor11=#00bb00\ncolor12=#008800\ncolor13=#00ee00\ncolor14=#44ff44\ncolor15=#66ff66\n',
    'catppuccin': 'background=#1e1e2e\nforeground=#cdd6f4\ncursor=#f5e0dc\ncolor0=#45475a\ncolor1=#f38ba8\ncolor2=#a6e3a1\ncolor3=#f9e2af\ncolor4=#89b4fa\ncolor5=#f5c2e7\ncolor6=#94e2d5\ncolor7=#bac2de\ncolor8=#585b70\ncolor9=#f38ba8\ncolor10=#a6e3a1\ncolor11=#f9e2af\ncolor12=#89b4fa\ncolor13=#f5c2e7\ncolor14=#94e2d5\ncolor15=#a6adc8\n',
}

def apply_color_theme(theme):
    if theme not in THEMES:
        return
    termux_dir = os.path.join(HOME,'.termux')
    os.makedirs(termux_dir, exist_ok=True)
    with open(os.path.join(termux_dir,'colors.properties'),'w') as f:
        f.write(THEMES[theme])
    run('termux-reload-settings 2>/dev/null || true')
    print(f'{LP}{G}[✔] Theme applied: {theme}{RS}')

# ══════════════════════════════════════════
#  BANNER MENU
# ══════════════════════════════════════════
def banner_config_menu():
    banner()
    cline('╔','╗'); cmid('STARTUP BANNER CONFIG',C); cline('╚','╝')
    print()
    cur_type = cfg.get('BANNER_TYPE','figlet')
    cur_text = cfg.get('BANNER_TEXT','Ter-Chan')
    cur_clr  = cfg.get('BANNER_COLOR','random')
    print(f'{LP}  {DIM}Current: [{cur_type}] "{cur_text}" color={cur_clr}{RS}')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Banner Type: Figlet + Lolcat  {"◀ active" if cur_type=="figlet" else ""}')
    print(f'{LP}  {C}[{W}02{C}]{G} Banner Type: Neofetch         {"◀ active" if cur_type=="neofetch" else ""}')
    print(f'{LP}  {C}[{W}03{C}]{G} Banner Type: Figlet + Neofetch{"◀ active" if cur_type=="both" else ""}')
    print(f'{LP}  {C}[{W}04{C}]{Y} Change Banner Text  (now: "{cur_text}")')
    print(f'{LP}  {C}[{W}05{C}]{Y} Banner Color: Random (lolcat) {"◀" if cur_clr=="random" else ""}')
    print(f'{LP}  {C}[{W}06{C}]{Y} Banner Color: Cyan            {"◀" if cur_clr=="cyan" else ""}')
    print(f'{LP}  {C}[{W}07{C}]{Y} Banner Color: Green           {"◀" if cur_clr=="green" else ""}')
    print(f'{LP}  {C}[{W}08{C}]{Y} Banner Color: Red             {"◀" if cur_clr=="red" else ""}')
    print(f'{LP}  {C}[{W}09{C}]{R} Remove Startup Banner')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if a in ('1','01'):
        cfg['BANNER_TYPE'] = 'figlet'; save_config(cfg)
        apply_all(); press_enter(); banner_config_menu()
    elif a in ('2','02'):
        cfg['BANNER_TYPE'] = 'neofetch'; save_config(cfg)
        apply_all(); press_enter(); banner_config_menu()
    elif a in ('3','03'):
        cfg['BANNER_TYPE'] = 'both'; save_config(cfg)
        apply_all(); press_enter(); banner_config_menu()
    elif a in ('4','04'):
        t = input(f'{LP}{Y}Enter banner text: {RS}').strip()
        if t:
            cfg['BANNER_TEXT'] = t; save_config(cfg)
            apply_all()
        press_enter(); banner_config_menu()
    elif a in ('5','05'):
        cfg['BANNER_COLOR'] = 'random'; save_config(cfg)
        apply_all(); press_enter(); banner_config_menu()
    elif a in ('6','06'):
        cfg['BANNER_COLOR'] = 'cyan'; save_config(cfg)
        apply_all(); press_enter(); banner_config_menu()
    elif a in ('7','07'):
        cfg['BANNER_COLOR'] = 'green'; save_config(cfg)
        apply_all(); press_enter(); banner_config_menu()
    elif a in ('8','08'):
        cfg['BANNER_COLOR'] = 'red'; save_config(cfg)
        apply_all(); press_enter(); banner_config_menu()
    elif a in ('9','09'):
        remove_block(ZSHRC, 'BANNER')
        print(f'{LP}{G}[✔] Startup banner removed from .zshrc{RS}')
        press_enter(); banner_config_menu()
    elif a in ('0','00'):
        menu()
    else:
        banner_config_menu()

# ══════════════════════════════════════════
#  PROMPT MENU
# ══════════════════════════════════════════
def prompt_menu():
    banner()
    cline('╔','╗'); cmid('ZSH PROMPT STYLE',C); cline('╚','╝')
    user = cfg.get('USERNAME','TyranRoot')
    host = cfg.get('HOSTNAME','Termux')
    cur  = cfg.get('PROMPT_STYLE','kali')
    print()
    print(f'{LP}  {DIM}Current username: {user}  |  hostname: {host}{RS}')
    print()
    styles = [
        ('kali',      f'┌──({user}@{host})-[~]\n{LP}       └─$'),
        ('arrow',     f'╔═[{user}@{host}]═[~]\n{LP}       ╚═▶'),
        ('minimal',   f'{user}@{host} ~ ❯'),
        ('hacker',    f'[root@{host}]-[~]\n{LP}       #'),
        ('powerline', f' {user}  {host}  ~ ▶'),
    ]
    for i, (name, preview) in enumerate(styles, 1):
        active = ' ◀ active' if cur == name else ''
        print(f'{LP}  {C}[{W}0{i}{C}]{G} {name.capitalize()} Style{R}{active}')
        print(f'{LP}  {DIM}       {preview}{RS}')
        print()
    print(f'{LP}  {C}[{W}06{C}]{Y} Change Username')
    print(f'{LP}  {C}[{W}07{C}]{Y} Change Hostname')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    style_map = {'1':'kali','01':'kali','2':'arrow','02':'arrow',
                 '3':'minimal','03':'minimal','4':'hacker','04':'hacker',
                 '5':'powerline','05':'powerline'}

    if a in style_map:
        cfg['PROMPT_STYLE'] = style_map[a]
        save_config(cfg)
        apply_all()
        press_enter(); prompt_menu()
    elif a in ('6','06'):
        u = input(f'{LP}{Y}New username: {RS}').strip()
        if u: cfg['USERNAME'] = u; save_config(cfg); apply_all()
        press_enter(); prompt_menu()
    elif a in ('7','07'):
        h = input(f'{LP}{Y}New hostname: {RS}').strip()
        if h: cfg['HOSTNAME'] = h; save_config(cfg); apply_all()
        press_enter(); prompt_menu()
    elif a in ('0','00'):
        menu()
    else:
        prompt_menu()

# ══════════════════════════════════════════
#  APPEARANCE MENU
# ══════════════════════════════════════════
def appearance_menu():
    banner()
    cline('╔','╗'); cmid('APPEARANCE & THEMES',C); cline('╚','╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} Install FiraCode Nerd Font')
    print(f'{LP}  {C}[{W}02{C}]{Y} Color Theme: Hacker Green')
    print(f'{LP}  {C}[{W}03{C}]{B} Color Theme: Kali Dark')
    print(f'{LP}  {C}[{W}04{C}]{M} Color Theme: Dracula')
    print(f'{LP}  {C}[{W}05{C}]{G} Color Theme: Matrix Black')
    print(f'{LP}  {C}[{W}06{C}]{M} Color Theme: Catppuccin')
    print(f'{LP}  {C}[{W}00{C}]{R} ← Back')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    theme_map = {'2':'hacker','02':'hacker','3':'kali','03':'kali',
                 '4':'dracula','04':'dracula','5':'matrix','05':'matrix',
                 '6':'catppuccin','06':'catppuccin'}
    if a in ('1','01'):
        install_font()
    elif a in theme_map:
        apply_color_theme(theme_map[a])
        press_enter(); appearance_menu()
    elif a in ('0','00'):
        menu()
    else:
        appearance_menu()

# ══════════════════════════════════════════
#  SECURITY MENU
# ══════════════════════════════════════════
def do_add_lock():
    print(f'\n{LP}{C}[▶] Setting up terminal lock...{RS}')
    new_pass = getpass.getpass(f'{LP}{Y}Create Access Key: {RS}')
    lock = f"""
_tl_attempt=1
while [ $_tl_attempt -le 3 ]; do
    echo -e "\\n\\033[1;36m╔══════════════════════════════════════╗"
    echo -e "║  \\033[1;31m⬡ TER-CHAN — SECURE ACCESS \\033[1;36m         ║"
    echo -e "╚══════════════════════════════════════╝\\033[0m"
    echo -n "\\033[1;33m  [Attempt $_tl_attempt/3] Access Key: \\033[0m"
    read -rs _tl_pass
    echo
    if [ "$_tl_pass" = "{new_pass}" ]; then
        echo -e "\\033[1;32m  ✔ ACCESS GRANTED\\033[0m"
        sleep 0.5; clear; break
    else
        echo -e "\\033[1;31m  ✘ DENIED\\033[0m"
        [ $_tl_attempt -eq 3 ] && exit 1
        _tl_attempt=$((_tl_attempt+1)); sleep 0.5
    fi
done
"""
    write_block(ZSHRC, 'LOCK', lock)
    print(f'{LP}{G}[✔] Lock added to .zshrc{RS}')
    press_enter(); security_menu()

def do_remove_lock():
    remove_block(ZSHRC, 'LOCK')
    print(f'{LP}{G}[✔] Lock removed from .zshrc{RS}')
    press_enter(); security_menu()

def security_menu():
    banner()
    cline('╔','╗'); cmid('SECURITY',C); cline('╚','╝')
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

# ══════════════════════════════════════════
#  TOOL BANNER (screen এ দেখায়)
# ══════════════════════════════════════════
def banner():
    os.system('clear')
    print()
    print(f'{C}{LP}  ████████╗███████╗██████╗      ██████╗██╗  ██╗ █████╗ ███╗   ██╗{RS}')
    print(f'{C}{LP}     ██╔══╝██╔════╝██╔══██╗    ██╔════╝██║  ██║██╔══██╗████╗  ██║{RS}')
    print(f'{G}{LP}     ██║   █████╗  ██████╔╝    ██║     ███████║███████║██╔██╗ ██║{RS}')
    print(f'{G}{LP}     ██║   ██╔══╝  ██╔══██╗    ██║     ██╔══██║██╔══██║██║╚██╗██║{RS}')
    print(f'{R}{LP}     ██║   ███████╗██║  ██║    ╚██████╗██║  ██║██║  ██║██║ ╚████║{RS}')
    print(f'{R}{LP}     ╚═╝   ╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝{RS}')
    print()
    cline('╔','╗')
    cmid('Ter-Chan — Termux Customization v3.0', W)
    cmid('Zsh Edition | Python Powered', DIM)
    cline('╚','╝')
    print()
    print(f'{LP}  {R}[!]{W} User   : {C}{cfg.get("USERNAME","TyranRoot")}{RS}')
    print(f'{LP}  {R}[!]{W} Host   : {C}{cfg.get("HOSTNAME","Termux")}{RS}')
    print(f'{LP}  {R}[!]{W} Prompt : {C}{cfg.get("PROMPT_STYLE","kali")}{RS}')
    print(f'{LP}  {R}[!]{W} Banner : {C}{cfg.get("BANNER_TYPE","figlet")} / {cfg.get("BANNER_TEXT","Ter-Chan")}{RS}')
    print()

# ══════════════════════════════════════════
#  MAIN MENU
# ══════════════════════════════════════════
def menu():
    banner()
    cline('╔','╗'); cmid('MAIN MENU',C); cline('╚','╝')
    print()
    print(f'{LP}  {C}[{W}01{C}]{G} 📦 Install All Dependencies')
    print(f'{LP}  {C}[{W}02{C}]{C} 🎨 Startup Banner Settings')
    print(f'{LP}  {C}[{W}03{C}]{Y} 💻 Zsh Prompt Style')
    print(f'{LP}  {C}[{W}04{C}]{M} 🖌️  Appearance & Color Themes')
    print(f'{LP}  {C}[{W}05{C}]{B} 🔒 Security Lock')
    print(f'{LP}  {C}[{W}06{C}]{G} ✅ Apply All Changes Now')
    print(f'{LP}  {C}[{W}00{C}]{R} ✖  Exit')
    print()
    a = input(f'{LP}{C}Selection ❯ {RS}').strip()

    if   a in ('1','01'): install_deps()
    elif a in ('2','02'): banner_config_menu()
    elif a in ('3','03'): prompt_menu()
    elif a in ('4','04'): appearance_menu()
    elif a in ('5','05'): security_menu()
    elif a in ('6','06'):
        apply_all(); press_enter(); menu()
    elif a in ('0','00'):
        print(f'\n{LP}{C}Goodbye, {cfg.get("USERNAME","TyranRoot")}. Stay hacking. 🔐{RS}')
        print(f'{LP}{Y}Run: source ~/.zshrc  — to apply changes{RS}\n')
        sys.exit(0)
    else:
        menu()

if __name__ == '__main__':
    try:
        menu()
    except KeyboardInterrupt:
        print(f'\n\n{LP}{C}Goodbye. Stay hacking. 🔐{RS}\n')
        sys.exit(0)
