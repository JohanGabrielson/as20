#!/usr/bin/env python3
import platform
import time
system = platform.system()
import os

# Virus signature (harmless, used for AV-testing)
eicar_str = r"X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"

# Check which OS is being used. 
if system == "Windows":
    # Save EICAR file in downloads
    print ("Windows OS detected. The script will continue.")
    file_path = os.path.expanduser("~/Downloads/eicar_test.txt")

elif system == "Linux":
    print("Linux detected. This script is intended for Windows.")
    exit()

elif system == "Darwin":
    print("macOS detected. This script is intended for Windows.")
    exit()

else:
    print(f"Unknown OS ({system}). This script is intended for Windows.")
    exit()

# Try to create the file
try:
    with open(file_path, "w") as f:
        f.write(eicar_str)
    print(f"[+++] EICAR test file created: {file_path}")
    print("[---] This file is harmless but should be detected by antivirus software.")
except Exception as e:
    print("[!!!] Could not create the file.")
    exit()

# wait so the antivirus can react
time.sleep(10)

if os.path.exists(file_path):
    try:
        with open(file_path, "r") as f:
            file_content = f.read()
        if file_content == eicar_str:
            print("[+++] File still exists and matches the EICAR signature.")
            print("[---] Antivirus software may not have reacted to it yet.")
        else:
            print("[???] File still exists but does not match EICAR signature.")
    except:
        print("[!!!] File exists but could not be read.")
        print("[!!!] Antivirus may have locked or quarantined the file.")
else:
    print("[!!!] File could not be found.")
    print("[!!!] Antivirus has most likely removed the file.")
