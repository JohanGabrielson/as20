#!/bin/bash

# ==== Logging ====

# Logfile path
Logfile="$HOME/password_checker.log"

# Create logfile if it does not exist and add permissions
if [[ ! -f "$Logfile" ]]; then
    sudo touch "$Logfile"
    sudo chmod 644 "$Logfile"
fi

log_event() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp [$level] $message" >> "$Logfile"

}

log_event "INFO" "SCRIPT STARTED"

# ==== Environment check ====
# Check that OS is Linux
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "Error: Thiws script must be run on Linux."
    exit 1
fi

# ==== Check Internet connection ====
if ! curl -s --head https://api.pwnedpasswords.com > /dev/null; then
    echo "Error. No Internet connection: Can't check for online leaks."
    exit 1
fi

# ==== Check that wordlist is available ====
Wordlist="/usr/share/wordlists/rockyou.txt"
if [[ ! -f "$Wordlist" ]]; then # Check if file is available
    echo "WARNING: rockyou.txt is not found, local wordlist check is not available."
fi

# ==== Check so script is not running as root ====

if [[ "$EUID" -eq 0 ]]; then
    echo "WARNING: Script is running as root. This is not recommended."
fi


# ==== Function: Check complexity and length  ====
# ====            =====
# ==== Purpose: check that password has       ====
# ==== a sufficient length and contains a digit
# ==== ======== =====
check_length_and_complexity() {
    local pw="$1" # Takes password as first argument 
    log_event "INFO" "Checking password length and complexity"
    # Checks password length
    if [[ ${#pw} -lt 8 ]]; then 
        log_event "ERROR" "Password is too short"
        echo "Password is too short (min 8 characters)"
        return 1
    fi

    # Checks that password contain A-Z, a-z, 0-9
    if ! [[ "$pw" =~ [A-Z] && "$pw" =~ [a-z] && "$pw" =~ [0-9] ]]; then
        log_event "ERROR" "Password lacks complexity (must contain uppercase, lowercase and digits)"
        echo "Password lacks complexity (must include capital lettes, lowercase and digits)"
        return 1
    fi
    # Save to logfile
    log_event "INFO" "Password complexity and length OK" 
    return 0 # All ok, criteria is met
}

# ==== Function: Check wordlist  =====
# ====           =====           =====
# ==== Purpose: Check if password is in rockyou.txt 
# ==== ======== =====

check_local_wordlist() {
    local pw="$1"
    # Wordlist pathway
    local wordlist="/usr/share/wordlists/rockyou.txt"
    log_event "INFO" "Checking local wordlist: rockyou.txt"
    # Checking if there is a match
    if grep -Fxq "$pw" "$wordlist"; then
        log_event "WARNING" "Password is listed in rockyou.txt"
        echo "Password is listed in  rockyou.txt - choose another."
        return 1
    fi
    log_event "INFO" "Password not found in rockyou.txt"
    return 0 # Not found in rockyou.txt
}

# ==== Function: Check online leaks  ====
# ====           =====
# ==== Purpose: Check if password is in known dataleaks 
# ==== ======== ====
check_online_leak() {
    local pw="$1"
    # Hash password with sha-1 and convert to uppercase letters
    local sha1=$(printf "%s" "$pw" | sha1sum | awk '{print toupper($1)}')
    # Split password in prefix (5 characters) and suffix (remaining)
    local prefix=${sha1:0:5}
    local suffix=${sha1:5}
    
    #Retrieve all hash-suffix matching the prefix
    local response=$(curl -s "https://api.pwnedpasswords.com/range/$prefix")

    log_event "INFO" "Checking online leaks (HIBP API)."
    # Check if it is available in the API response
    if echo "$response" | grep -q "^$suffix:"; then
        echo "Password has occured in leaks - choose another."
        return 1
    fi
    log_event "INFO" "Password not found in online leaks."
    return 0 #Password is not in leak
}

# ==== MAIN ====

# -s makes the characters hidden when entered
read -s -p  "Enter a password to check: " password
echo "" 

log_event "INFO" "Password check initiated."
# Run the functions one by one, if 1 is returned it is cancelled
check_length_and_complexity "$password" || {
    log_event "ERROR" "Complexity check failed" 
    exit 1
}

check_local_wordlist "$password" || {
    log_event "ERROR" "Wordlist check failed" 
    exit 1 
}

check_online_leak "$password" || {
    log_event "ERROR" "Online leak check failed " 
    exit 1
}

log_event "INFO" "Password approved"
# If everything passes: 
echo "Password is approved."


