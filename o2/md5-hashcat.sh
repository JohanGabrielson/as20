#!/bin/bash
# 
# Use: ./md5-hashcat.sh [HASH_FILE] [MASK] 

# Check that hashcat is installed 
if ! command -v hashcat &> /dev/null; then
    echo "ERROR: hashcat är inte installerat!"
    echo "To install: sudo apt install hashcat"
    exit 1
fi

echo "=== Hashcat MD5 Cracker ==="
hashcat --version | head -n 1
echo "==========================="

# Standard settings
HASH_FILE="${1:-mina_hashar.txt}"
MASK="${2:-?d?d?d?d?d?}"  			# HASH_TYPE="0"    # 0=MD5 hash mode
ATTACK_MODE="3"  				# USe Mask attack

echo "Starting hashcat ..."
echo "=================="

# run hashcat
hashcat -m "$HASH_TYPE" -a "$ATTACK_MODE" "$HASH_FILE" "$MASK" -O -w 3 --force

echo ""
echo "=================="
echo "Hashcat run complete! All OK!"
