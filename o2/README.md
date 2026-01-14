### Overview

This contains two tools to generate and test MD5 hashes:

## Code description:

# md5-hashcat.sh 
Bash script that runs hashcat to crack MD5 hashes. The script checks that hashcat is 
installed and starts a mask attack. 

# generate_md5.py
Python script that generates random passwords and print their  MD5 hashes. The 
password length has a sufficient length to resist attack of rainbow tables. 

# my-hashes.txt
Textfile that contains 10 hashes that the Python script generates. 


## Usage:
Before running the Bash script:

``` 
chmod +x md5-hashcat.sh
```

To run the Bash script: 

``` 
./md5-hashcat.sh
```

To run the Python script: 

``` 
python3 generate-md5.py

```
