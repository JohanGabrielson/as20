#!/usr/bin/env python3

import random
import hashlib

# Generate random password with letters and digits. Length is decided by variable 
# PWD_LGT (found in the end of this script)
def generate_random_number_string():

    return ''.join(random.choice("0123456789abcdefghijklmnopqrstuvwxyz") for X in range(PWD_LGT))
# Receives string and returns MD5 hash in hexadecimal format. Function i used to generate 
# hash values
def md5_hash(text):

    return hashlib.md5(text.encode()).hexdigest()

# main function generates number of random passwords defined by NO_PASS
# which length is decided by PWD_LGT and hashed using md5 and prints the  
# hashes.
def main():

    for i in range(NO_PASS):
        password = generate_random_number_string()
        hash_value = md5_hash(password)
        print( hash_value )

# password length
PWD_LGT = 11
# number of passwords/hashes
NO_PASS = 10


if __name__ == "__main__":
    main()
