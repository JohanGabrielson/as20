#!/bin/bash

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
WORDLIST="/usr/share/wordlists/rockyou.txt"
if [[ ! -f "$WORDLIST" ]]; then # Check if file is available
    echo "WARNING: rockyou.txt is not found, local wordlist check is not available."
fi


# ==== Function: Check complexity and length  ====
# ====            =====
# ==== Purpose: check that password has       ====
# ==== a sufficient length and contains a digit
# ==== ======== =====
check_length_and_complexity() {
    local pw="$1" # Takes password as first argument 

    # Checks password length
    if [[ ${#pw} -lt 8 ]]; then 
        echo "Password is too short (min 8 characters)"
        return 1
    fi

    # Checks that password contain A-Z, a-z, 0-9
    if ! [[ "$pw" =~ [A-Z] && "$pw" =~ [a-z] && "$pw" =~ [0-9] ]]; then
        echo "Password lacks complexity (must include capital lettes, lowercase and digits)"
        return 1
    fi
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
    # Checking if there is a match
    if grep -Fxq "$pw" "$wordlist"; then
        echo "Password is listed in  rockyou.txt - choose another."
        return 1
    fi
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
    # Check if it is available in the API response
    if echo "$response" | grep -q "^$suffix:"; then
        echo "Password has occured in leaks - choose another."
        return 1
    fi
    return 0 #Password is not in leak
}

# ==== MAIN ====

# -s makes the characters hidden when entered
read -s -p  "Enter a password to check: " password
echo "" 
# Run the functions one by one, if 1 is returned it is cancelled
check_length_and_complexity "$password" || exit 1
check_local_wordlist "$password" || exit 1
check_online_leak "$password" || exit 1
# If everything passes: 
echo "Password is approved."


