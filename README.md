# 🛡️ Password Security Checker
A Bash-based password auditing tool to check strength, complexity, check against local wordlist and online leaks.

## 📌 Functionality 
- Length: min 8 characters
- Complexity: Uppercase, lowercase, special character and digit(s)
- No whitespace allowed
- Checking against local wordlist (rockyou.txt)
- Checking against HaveIBeenPwned API
- Color coded layout
- Logging to file (possible to disable)
- Warning if run as root

## 🧩 Requirements
- Linux (Script will terminate if ≠ Linux)
- curl
- Internet connection
- rockyou.txt (must be unpacked)



## 📥 Installation 
```bash
git clone https://github.com/JohanGabrielson/as20/
cd as20/projekt
chmod +x check_password.sh
```

## 🔐 Permissions 
- Make the script executable:
```bash
chmod +x check_password.sh
```

The program will automatically create a log file, permissions are set to be read and write by all users:
```bash
-rw-rw-rw- 1 user user password_checker.log
```
Unpack rockyou.txt
```bash
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
```

## ▶️ Usage 
- Run by command:
```bash/check_password.sh ```

### Available flags

| Flag         | Function                    |
|--------------|-----------------------------|
| `-h`, `--help`     | Show help text             |
| `-v`, `--version`  | Show version and author    |
| `--nolog`          | Disable logging            |
| `--debug`          | Enable debug mode          |
| `--man`            | Show manual                |


Example: 

```bash
 ./check_password.sh --debug
```


## 📄 Logging 
Data is logged to password_checker.log in the same folder as the script is located in.
Log levels:
- INFO
- WARNING
- ERROR
- DEBUG (if enabled)


## 📸 Example output
<p align="center">
<img width="1967" height="958" alt="Skärmbild 2026-01-09 140415" src="https://github.com/user-attachments/assets/2441d92f-dca0-42c8-8adc-4aec1f428d7d" /></p>


## 👤 Author and version
Created by Johan, version 1.0


## 📜 License and purpose
This script was created for educational purposes within IT and Cybersecurity training.
Free to use for anyone, anywhere, anytime.


## ⚙️ How it works
1. User enters a password (input is hidden)
2. Script validates:
- Length
- Complexity
- Whitespace
3. Script checks:
  - Local wordlist (rockyou.txt)
  - Online leaks (HaveIBeenPwned API)
4. Script logs all events
5. User chooses to try again or exit


## ⚠️  Known limitations 
- Requires Internet connection for HIBP check
- rockyou.txt has to be manually unpacked
- Script is designed for Linux only

##  🗂️  Version History
- **1.0** - Initial release
