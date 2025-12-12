#!/usr/bin/env python3
# -*- -*- -*-

import random
import hashlib

def generate_random_number_string():
    
    return ''.join(random.choice("0123456789abcdefghijklmnopqrstuvwxyz") for X in range(PWD_LGT))

def md5_hash(text):
 
    return hashlib.md5(text.encode()).hexdigest()

def main():
    
    for i in range(NO_PASS):
        
        password = generate_random_number_string()
        
       
        hash_value = md5_hash(password)
        
        
        print( hash_value )
    
  


PWD_LGT = 11

NO_PASS = 10


if __name__ == "__main__":
    main()
