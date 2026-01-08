#!/bin/bash

# ==== Color codes =====
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

# ====Log / print functions  ====
info()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warn()    { echo -e "${YELLOW}[WARNING]${RESET} $1"; }
error()   { echo -e "${RED}[ERROR]${RESET} $1"; }
debug()   { [[ $DEBUG == true ]] && echo -e "${MAGENTA}[DEBUG]${RESET} $1"; }



# ==== Version info  ====
SCRIPT_VERSION="1.0"
SCRIPT_AUTHOR="Johan"

NOLOG=false
DEBUG=false

# ==== Help  ====
show_help() {
    echo "Password Checker Script"
    echo ""
    echo "This script checks password strength, compares against rockyou.txt and checks if the  password is in known data breaches."
    echo ""
    echo "Usage $0 [OPTONS]"
    echo ""
    echo "Options:"
    echo " -h,  --help      Show this help message and exit" 
    echo " -v,  --version   Show verion and author"
    echo "      --nolog     Disable logging to file"
    echo "      --debug     Enable debugging"
    echo ""
    echo ""
    echo "Examples:"
    echo "  $0              Start the interactive password checker"
    echo "  $0 --help       Show help information"
    echo "  $0 --version    Show version and author"
    echo ""


}

# ==== Version ====
show_version() {
    echo "Password checker script v$SCRIPT_VERSION"
    echo "Developed by $SCRIPT_AUTHOR"
}

show_man() {
    cat << 'EOF'
NAME
    check_password.sh - Interactive Password Checker
SYNOPSIS
    check_password.sh
DESCRIPTION
    This script evaluates password strength by checking:
    - Length and complexity requirements
    - Presence in the local rockyou.txt wordlist
    - Exposure in online leaks via HaveIBeenPwned API
    
   The script supports logging, debug mode and interactive retry prompt

OPTIONS
    -h, --help
        Show a short help message.

    -v, --version
        Show version and author info.

    --nolog
        Disavble logging to file.

    --debug
        Enable verbose debug output.

    --man
        Show this manual page.

EXAMPLES
    check_password.sh
        Start the password checker.

    check_password.sh --debug
        Run with debug enabled.

    check_password.sh --nolog
        Run without writing to logfile.

EXIT STATUS
    0 Successful execution
    1 Invalid option or error during execution

FILES
    $HOME/password_checker.log
        Log file used for script events

    /usr/share/wordlist/rockyou.txt
        Local wordlist used for password comparision

SEE ALSO
    sha1sum(1), curl(1)

AUTHOR
    Johan

VERSION 
    1.0

EOF

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
       --man) 
           show_man
           exit 0
           ;;
       --nolog)
           NOLOG=true
           info "[INFO] Logging disabled"
           ;;
       --debug)
           DEBUG=true
           debug "[DEBUG] Debug mode enabled"
           ;;
       *) error "Unknown option: $1"
          echo "Use --help for usage information"
          exit 1
          ;;
    esac
fi

# ==== Header  =====

show_header() { 
    local now=$(date "+%Y-%m-%d %H:%M:%S")

        echo -e "${MAGENTA}"
    echo "┌──────────────────────────────────────────────┐"
    echo "│              PASSWORD SECURITY CHECKER       │"
    echo "├──────────────────────────────────────────────┤"

    printf "│  %-43s │\n" "Version : $SCRIPT_VERSION"
    printf "│  %-43s │\n" "Author  : $SCRIPT_AUTHOR"
    printf "│  %-43s │\n" "Date    : $now"

    echo "└──────────────────────────────────────────────┘"
    echo -e "${RESET}"


}

show_header


#=== Logging ====

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
    
    # Skip logging if NOLOG=TRUE
    if [[ "$NOLOG" == true ]]; then
        return
    fi

    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$timestamp [$level] $message" >> "$Logfile"

}

log_event "INFO" "SCRIPT STARTED"

# ==== Environment check ====
# Check that OS is Linux, exit otherwise
if [[ "$(uname -s)" != "Linux" ]]; then
    error "Error: This script must be run on Linux. You will now exit."
    log_event "ERROR" "Script is not running on Linux"
    exit 1
fi

# Check that curl is installed
if ! command -v curl >/dev/null 2>&1; then
    error "Error: curl is not installed. Please install curl and try again. You will now exit"
    log_event "ERROR" "Curl not available"
    exit 1
fi
 

# ==== Check Internet connection ====
if ! curl -s https://www.google.com >/dev/null; then  
    error "Error: No internet connection. You will now exit."
    log_event "ERROR" "No Internet connection"
    exit 1
fi
 

# ==== Check that wordlist is available, warning to user if it is not available ====
Wordlist="/usr/share/wordlists/rockyou.txt"
if [[ ! -f "$Wordlist" ]]; then # Check if file is available
    warn "WARNING: rockyou.txt is not found, local wordlist check is not available."
    log_event "WARNING" "rockyou.txt is missing"
fi

# ==== Check so script is not running as root, if so warning to user  ====

if [[ "$EUID" -eq 0 ]]; then
    warn "WARNING: Script is running as root. This is not recommended."
    log_event "WARNING" "Script is running as root"
fi


# ==== Function: Check complexity and length  ====
# ====            =====
# ==== Purpose: check that password has       ====
# ==== a sufficient length and contains a digit
# ==== ======== =====
check_length_and_complexity() {
    local pw="$1" # Takes password as first argument 
    
    debug "Starting complexity check"
    debug "Password length: ${#pw}"

    log_event "INFO" "Checking password length and complexity"
    # Checks password length
    if [[ ${#pw} -lt 8 ]]; then
        debug "Password too short: ${#pw} characters" 
        error "Password is too short (min 8 characters)"
        log_event "ERROR" "Password is too short"
        return 1
    fi

    # Checks that password contain A-Z, a-z, 0-9
    if ! [[ "$pw" =~ [A-Z] && "$pw" =~ [a-z] && "$pw" =~ [0-9] ]]; then
        debug "Password failed complexity check"
        log_event "ERROR" "Password lacks complexity"
        error "Password lacks complexity (must include capital lettes, lowercase and digits)"
        return 1
    fi
  
    # Special characters
    if ! [[ "$pw" =~ [^A-Za-z0-9] ]]; then
        debug "Password missing special character"
        log_event "ERROR" "Password missing special character"
        error "Password must include one special character"
        return 1
    fi


    debug "Password passed complexity check"
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
 
    debug "Starting local wordlist check"
 
    # Wordlist pathway
    local wordlist="/usr/share/wordlists/rockyou.txt"
    debug "Wordlist path: $wordlist"
    log_event "INFO" "Checking local wordlist: rockyou.txt"
    # Checking if there is a match
    if grep -Fxq "$pw" "$wordlist"; then
        debug "Password found in rockyou.txt"
        log_event "WARNING" "Password is listed in rockyou.txt"
        warn "Password is listed in  rockyou.txt - You should choose another."
        return 1
    fi
    debug "Password not found in rockyou.txt"
    log_event "INFO" "Password not found in rockyou.txt"
    return 0 # Not found in rockyou.txt
}

# ==== Function: Check online leaks  ====
# ==== Purpose: Check if password is in known dataleaks 
# ==== ======== ====
check_online_leak() {
    local pw="$1"

    debug "Starting online leak check"

    # Hash password with sha-1(needed to work with HIBP) and convert to uppercase letters
    local sha1=$(printf "%s" "$pw" | sha1sum | awk '{print toupper($1)}')
    debug "SHA-1 hash (uppercase): $sha1"
   
    # Split password in prefix (5 characters) and suffix (remaining)
    local prefix=${sha1:0:5}
    local suffix=${sha1:5}
    
    debug "haveibeenpwned prefix: $prefix"
    debug "haveibeenpwned suffix: $suffix" 
   

    #Retrieve all hash-suffix matching the prefix
    debug "Sending request to haveibeenpwned api..."
    local response=$(curl -s "https://api.pwnedpasswords.com/range/$prefix")

    log_event "INFO" "Checking online leaks (HIBP API)."
    # Check if it is available in the API response
    if echo "$response" | grep -q "^$suffix:"; then
        debug "haveibeenpwned match found for suffix: $suffix"
        warn "Password has occured in leaks - You should choose another."
        return 1
    fi
    debug "No match found in haveibeenpwned respose"
    log_event "INFO" "Password not found in online leaks."
    return 0 
}

# ==== MAIN ====


while true; do
    # Ask user to enter password + confirm password, loop if no match
    echo -n  "Enter a password to check: "
    read -s password
    echo ""
    echo -n  "Confirm password: "
    read -s password_confirmed
  
    echo ""
    
    if [[ "$password" != "$password_confirmed" ]]; then
        error "Passwords are not matching. Please try again."
        log_event "Passwords are not matching"
        continue
    fi

    echo "" 
    log_event "INFO" "Password check initiated."

    # Checks for empty password or spaces
    if [[ -z "$password" || "$password" =~ ^[[:space:]]+$  ]]; then
        error "Password cannot be empty or only spaces. Please try again."
        log_event "ERROR" "Empty or whitespace-only password entered"
        continue
    fi

    
    

    if ! check_length_and_complexity "$password"; then
        log_event "ERROR" "Complexity check failed"
    elif ! check_local_wordlist "$password"; then
        log_event "ERROR" "Wordlist check failed"
    elif ! check_online_leak "$password"; then
        log_event "ERROR" "Online leak check failed"
    else 
        success "Password is approved."
        log_event "INFO" "Password is approved"
        break 
    fi

    # Check if the user wants to try again
    echo ""
    read -p "Do you want to try another password? Select no (n) to exit (y/n):" choice

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
           echo "Invalid option. Try again (y/n):"
           ;;


   esac 
done

