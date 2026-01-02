#!/usr/bin/env python3
import platform
import time
system = platform.system()
import os


eicar_str = r"X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*"

if system == "Windows":
    print ("Windows OS upptäckt. Skriptet fortsätter")
    file_path = os.path.expanduser("C:/Users/johan/.vscode/3/eicar_test.txt")



   
elif system == "Linux":
    print("Linux upptäckt...Fortsätter.")
    file_path = os.path.expanduser("~/eicar_test.txt")

elif system == "Darwin":
    print("macOS upptäckt. Detta script är avsett för Windows.")
    exit()

else:
    print(f"Okänt operativsystem ({system}). Detta script är avsett för Windows. Avbryter körning.")
    exit()

try: 
    with open(file_path, "w") as f:
        f.write(eicar_str)
    print(f"[+++] EICAR-testfil skapad: {file_path}")
    print("[---] OBS: denna fil är ofarlig men ska upptäckas av antivirusprogram")
except Exception as e:
    print("[!!!] Kunde inte skapa filen.")
    exit()

time.sleep(3)

if os.path.exists(file_path):
    try:
        with open(file_path, "r") as f:
	    file_content = f.read()
       
	if file_content == eicar_str:
        print("[+++] Filen finns kvar och matchar EICAR-signaturen")
        print("[---] Kan betyda att antivirus inte har reagerat ännu")
	else:
	    print("[???] Filen finns kvar men innehållet matchar inte EICAR-signaturen")
    except:
        print("[!!!] Filen kunde inte läsas.")
	print("[!!!] Antivirus har tagit bort filen.")
else: 
    print"([!!!] Filen kunde inte hittas.)"
    print"([!!!] Antivirus har tagit bort filen)"
