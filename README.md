# 🍯 TyraxZero HoneyPot System v1.0

```
████████╗██╗   ██╗██████╗  █████╗ ██╗  ██╗███████╗██╗     ██╗████████╗███████╗
   ██╔══╝╚██╗ ██╔╝██╔══██╗██╔══██╗╚██╗██╔╝██╔════╝██║     ██║╚══██╔══╝██╔════╝
   ██║    ╚████╔╝ ██████╔╝███████║ ╚███╔╝ █████╗  ██║     ██║   ██║   █████╗
   ██║     ╚██╔╝  ██╔══██╗██╔══██║ ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██╔══╝
   ██║      ██║   ██║  ██║██║  ██║██╔╝ ██╗███████╗███████╗██║   ██║   ███████╗
   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝

         HoneyPot System v1.0 — Professional Defensive Security Tool
```

> **Author:** TyraxZero
> **Version:** 1.0
> **Platform:** Kali Linux / Termux / Any Python 3 System
> **License:** For Authorized & Ethical Use Only

---

## 📋 Table of Contents

- [What is a Honeypot?](#what-is-a-honeypot)
- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [Usage](#usage)
- [Dashboard Guide](#dashboard-guide)
- [Honeypot Traps](#honeypot-traps)
- [Attack Detection](#attack-detection)
- [Project Structure](#project-structure)
- [Legal Notice](#legal-notice)

---

## 🤔 What is a Honeypot?

A **honeypot** is a cybersecurity mechanism that creates a decoy system designed
to look like a real vulnerable target. When attackers probe or attack it, every
single action is silently captured and logged — giving defenders:

- **Real threat intelligence** about attacker techniques
- **Early warning** of ongoing attacks
- **IP data** of malicious actors
- **Attack pattern analysis** for better defense

This project simulates common vulnerable endpoints (admin panels, databases,
config files) and records everything attackers do.

---

## ✨ Features

### 🖥️ Dashboard
- **Matrix-style hacker UI** with real-time attack feed
- **Auto-refresh every 3 seconds** — live data, no page reload needed
- **Severity-rated alerts** — CRITICAL / HIGH / MEDIUM / LOW
- **Stat cards** — Total attacks, Today's attacks, Blocked IPs, Uptime
- **Hourly activity chart** — see when attacks peak
- **Attack type distribution** bar chart
- **Top attacker IP** leaderboard
- **Blocked IP manager** — view and unblock IPs
- **Terminal-style event log** view

### 🪤 Honeypot Traps
- Fake Admin Panel (`/admin`, `/administrator`)
- Fake WordPress Login (`/wp-admin`)
- Fake phpMyAdmin (`/phpmyadmin`, `/pma`)
- Fake sensitive files (`.env`, `.git/HEAD`, `config.php`, `backup.sql`)
- Fake REST API (`/api/v1/users`, `/graphql`)
- Fake search endpoint (SQLi bait)
- Path traversal bait (`/file?path=`)

### 🔍 Attack Detection
- SQL Injection detection
- XSS (Cross-Site Scripting) detection
- Path Traversal detection
- Admin panel probing
- Scanner tool fingerprinting (nmap, nikto, sqlmap, etc.)
- Credential stuffing attempts
- API endpoint abuse

### 📊 Logging & Reporting
- **SQLite database** for persistent storage
- **Text log file** (`logs/attacks.log`)
- Auto-blocked IPs after repeated hits
- Export-ready data

---

## 📸 Dashboard Preview

```
╔══════════════════════════════════════════════════════════════════╗
║  TYRAXZERO HONEYPOT v1.0          STATUS: ● ACTIVE    22:14:35  ║
╠══════════╦═══════════════════════════════════════════════════════╣
║          ║  [TOTAL]    [TODAY]    [BLOCKED]    [UPTIME]         ║
║ Dashboard║   1,247      84          32          2h 14m          ║
║ Live Feed║                                                       ║
║ Blocked  ║  ── Live Attack Feed ──────────────────────────────  ║
║ Analytics║  22:14:33  192.168.1.5  ADMIN_PROBE    /wp-admin     ║
║ Logs     ║  22:14:31  10.0.0.22   SQL_INJECTION  q=' OR 1=1    ║
║          ║  22:14:28  172.16.0.8  SCANNER        nikto/2.1.6   ║
╚══════════╩═══════════════════════════════════════════════════════╝
```

---

## 🚀 Installation

### Termux (Android)
```bash
# Update packages
pkg update && pkg upgrade

# Install Python
pkg install python

# Clone or extract project
cd tyraxzero_honeypot

# Install dependencies
pip install flask

# Run
python app.py
```

### Kali Linux
```bash
# Install dependencies
pip3 install flask

# Navigate to project
cd tyraxzero_honeypot

# Run
python3 app.py
```

### Any Linux/Mac
```bash
pip3 install -r requirements.txt
python3 app.py
```

---

## 💻 Usage

1. Start the honeypot:
   ```bash
   python3 app.py
   ```

2. Open dashboard in browser:
   ```
   http://localhost:5000
   ```

3. The honeypot is now **listening** on port 5000.

4. To expose on local network (other devices can probe it):
   ```
   http://YOUR_IP:5000
   ```

5. Watch the dashboard for incoming attacks in real time.

---

## 🖥️ Dashboard Guide

| Section | Description |
|---------|-------------|
| **Dashboard** | Overview with stats, live feed, charts |
| **Live Feed** | Full scrollable attack log |
| **Blocked IPs** | Manage auto-blocked attackers |
| **Analytics** | Attack type and IP distribution charts |
| **Event Log** | Terminal-style chronological log |

### Buttons
| Button | Action |
|--------|--------|
| `↺ Refresh` | Manually refresh data |
| `⊘ Clear Logs` | Wipe all attack records |
| `BLOCK` | Manually block an IP |
| `UNBLOCK` | Remove IP from blocklist |

---

## 🪤 Honeypot Traps

| Endpoint | Trap Type | Severity |
|----------|-----------|----------|
| `/admin` | Fake admin login | HIGH |
| `/wp-admin` | Fake WordPress | HIGH |
| `/phpmyadmin` | Fake phpMyAdmin | HIGH |
| `/.env` | Fake env file (decoy creds) | HIGH |
| `/.git/HEAD` | Fake Git repo | HIGH |
| `/backup.sql` | Fake DB dump | HIGH |
| `/config.php` | Fake PHP config | HIGH |
| `/wp-config.php` | Fake WP config | HIGH |
| `/search?q=` | SQLi bait | CRITICAL |
| `/api/v1/users` | Fake API | MEDIUM |
| `/file?path=` | Path traversal bait | CRITICAL |
| `/comment` | XSS bait | HIGH |
| `/*` (catch-all) | Scanner detection | LOW–HIGH |

---

## 🔍 Attack Detection Logic

### SQL Injection
Detects payloads like: `'`, `" OR 1=1`, `UNION SELECT`, `DROP TABLE`, `SLEEP()`

### XSS
Detects: `<script>`, `javascript:`, `onerror=`, `alert(`, `document.cookie`

### Path Traversal
Detects: `../`, `/etc/passwd`, `/etc/shadow`, `C:\Windows`

### Scanner Detection
Identifies tools via User-Agent: `nmap`, `nikto`, `sqlmap`, `masscan`,
`burpsuite`, `hydra`, `zgrab`, `python-requests`

### Severity Levels
| Level | Color | Triggers |
|-------|-------|----------|
| CRITICAL | 🔴 Red | SQLi, Path Traversal, Credentials |
| HIGH | 🟠 Orange | Admin probes, Scanners, XSS |
| MEDIUM | 🟡 Yellow | API probes, Unknown tools |
| LOW | 🟢 Green | General path scanning |

---

## 📁 Project Structure

```
tyraxzero_honeypot/
│
├── app.py                  # Main Flask application
│
├── templates/
│   ├── dashboard.html      # Main hacker-UI dashboard
│   └── fake_login.html     # Honeypot fake login trap
│
├── data/
│   └── honeypot.db         # SQLite database (auto-created)
│
├── logs/
│   └── attacks.log         # Text log file (auto-created)
│
├── requirements.txt        # Python dependencies
└── README.md               # This file
```

---

## 🔧 Configuration

Edit `app.py` to customize:

```python
# Change port (default: 5000)
app.run(host="0.0.0.0", port=5000)

# Add more fake endpoints
@app.route("/your-trap")
def my_trap():
    log_attack(request.remote_addr, 80, "MY_TRAP", request.path, ...)
    return "decoy response"
```

---

## 📚 What You Learn From This Project

Running this honeypot teaches you:

- How attackers **enumerate** web servers
- What tools attackers use (nmap, nikto, sqlmap)
- Common attack patterns (SQLi, XSS, credential stuffing)
- How to build **threat intelligence** from real traffic
- Flask web development
- SQLite database usage
- Real-time dashboard with JavaScript

This is exactly the kind of project that impresses cybersecurity employers —
it shows hands-on understanding of both **offensive techniques** (knowing what
to simulate) and **defensive thinking** (capturing and analyzing threats).

---

## ⚖️ Legal & Ethical Notice

```
┌─────────────────────────────────────────────────────────┐
│  ⚠  IMPORTANT — READ BEFORE USE                        │
│                                                         │
│  • Deploy ONLY on systems you own                       │
│  • Do NOT use on public networks without permission     │
│  • Do NOT use to entrap legitimate users                │
│  • This is a DEFENSIVE & EDUCATIONAL tool               │
│  • Unauthorized deployment may be illegal               │
└─────────────────────────────────────────────────────────┘
```

---

## 🛠️ Built With

- **Python 3** — Core language
- **Flask** — Web framework
- **SQLite** — Database
- **JavaScript (Vanilla)** — Real-time dashboard
- **CSS** — Matrix hacker UI styling

---

*TyraxZero HoneyPot System v1.0 — Stay defensive, stay ethical. 🔐*
