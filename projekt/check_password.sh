#!/bin/bash


# ==== Version info  ====
SCRIPT_VERSION="1.0"
SCRIPT_AUTHOR="Johan"

# ==== Help  ====
show_help() {
    echo "Password Checker Script"
    echo ""
    echo "This script checks password strength, compares against rockyou.txt and checks if the  password is in known data breaches."
    echo ""
    echo "Usage $0 [OPTONS]"
    echo ""
    echo "Options:"
    echo " -h, --help     Show this help message and exit" 
    echo " -v,  --version Show verion and author"
    echo ""
    echo "Examples:"
    echo "  $0            Start the interactive password checker"
    echo "  $0 --help         Show help information"
    echo "  $0 --version  Show version and author"
    echo ""


}

# ==== Version ====
show_version() {
    echo "Password checker script v$SCRIPT_VERSION"
    echo "Developed by $SCRIPT_AUTHOR"
}


# ==== Arguments ====
if [[ $# -gt 0  ]]; then 
    case "$1" in
       -h|--help)
           show_help
           exit 0
           ;;
       -v|--version)
           show_version
           exit 0
           ;;
       *) echo "Unknown option: $1"
          echo "Use --help for usage information"
          exit 1
          ;;
    esac
fi

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
    log_event "ERROR" "Script is not running on Linux"
    exit 1
fi

# ==== Check Internet connection ====
if ! curl -s --head https://api.pwnedpasswords.com > /dev/null; then
    echo "ERROR" "No Internet connection: Can't check for online leaks."
    log_event "ERROR" "No Internet connection" 
    exit 1
fi

# ==== Check that wordlist is available ====
Wordlist="/usr/share/wordlists/rockyou.txt"
if [[ ! -f "$Wordlist" ]]; then # Check if file is available
    echo "WARNING: rockyou.txt is not found, local wordlist check is not available."
    log_event "WARNING" "rockyou.txt is missing"
fi

# ==== Check so script is not running as root ====

if [[ "$EUID" -eq 0 ]]; then
    echo "WARNING: Script is running as root. This is not recommended."
    log_event "WARNING" "Script is running as root"
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
        echo "Password is too short (min 8 characters)"
        log_event "ERROR" "Password is too short"
        return 1
    fi

    # Checks that password contain A-Z, a-z, 0-9
    if ! [[ "$pw" =~ [A-Z] && "$pw" =~ [a-z] && "$pw" =~ [0-9] ]]; then
       
        log_event "ERROR" "Password lacks complexity"
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
    # Hash password with sha-1(needed to work with HIBP) and convert to uppercase letters
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

while true; do

    # -s makes the characters hidden when entered
    read -s -p  "Enter a password to check: " password
    echo "" 
    log_event "INFO" "Password check initiated."
    

    if ! check_length_and_complexity "$password"; then
        log_event "ERROR" "Complexity check failed"
    elif ! check_local_wordlist "$password"; then
        log_event "ERROR" "Wordlist check failed"
    elif ! check_online_leak "$password"; then
        log_event "ERROR" "Online leak check failed"
    else 
        echo "Password is approved."
        log_event "ERROR" "Password is approved"
        break # Finishes the script once the password is approved
    fi

    # Check if the user wants to try again
    echo ""
    read -p "Do you want to try another password? (y/n):" choice

    case "$choice" in
        y|Y)
           log_event "INFO" "User chose to try again"
           echo ""
           ;;
        n|N)
           log_event "INFO" "User chose to exit script"
           echo "Exiting"
           exit 0
           ;;
        *) 
           log_event "WARNING" "Invalid menu selection"
           echo "Invalid option. Exiting."
           exit 1
           ;;

        
   
   esac
done

   
    


 
