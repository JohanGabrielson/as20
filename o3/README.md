### Overview
This project consists of a Python script that will test of an antivirus will detect an 
EICAR test string.

## Code description
The script will detect which operating system is in use and exist immediately if not 
Windows. After the EICAR file is created it will wait for a few seconds to check if it 
has been removed, quarantined or left untouched. An official EICAR test string is used:
this is harmless but should trigger an antivirus software. 

## Requirements 
<li> Python 3 </li>
<li> Windows system with antivirus software enabled</li>

## Usage 
```
python3 av-test.py 
```

If executed on Windows, the script will: 
<li> Create a file: eicar_test.txt  </li>
<li> Wait for a few seconds </li> 
<li> Report if the file has been removed or quarantined, or if nothing has happened  </li>



