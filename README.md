
### Password Security Checker ###

## 📌 Functionality ¤¤¤
- Length: min 8 characters
- Complexity: Uppercase, lowercase, special character and digit(s)
- No whitespace allowed
- checking against local wordlist
- checking against HaveIBeenPwned API
- Color coded layout
- Logging to file (possible to disable)
- Warning if run as root

## 🧩 Requirements: ##
- Linux (Script will terminate if != Linux)
- curl
- Internet connection
- rockyou.txt (it has to be unpacked)



## 📥 Installation ##
git clone https://github.com/JohanGabrielson/as20/
cd as20/projekt
chmod +x check_password.sh

## 🔐 Permission ##
- To run the script: chmod +x check_password.sh
The program will automatically create a log file, permissions are set to be read and write by all users (sudo not needed):
-rw-rw-rw- 1 user user password_checker.log

## ▶️ Usage ##
- Run by command: ./check_password.sh

Available flags: -h, --help       Visa hjälp
-v, --version    Visa version och författare
--nolog          Inaktivera loggning
--debug          Aktivera debug‑läge
--man            Visa manual

Example: 
./check_password.sh --debug


## Logging ##
Data is logged to password_checker.log in the same folder as the script is located in.
Logs:
- INFO
- WARNING
- ERROR
- DEBUG (if enabled)

## Permissions ##



