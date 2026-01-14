## Overview
This script collects system information from a Linux environment as a part of
reconnaissance (RECON). 
The purpose is to automatize data collection to gather information about the system, 
users, network, hardware and services. This can be used for security tests, 
troubleshooting or documentation of system status. 

The script will automatically generate a logfile with timestamps, for example: 
```
system_report_2025_12_20-12-45-33.txt ```

## Functionality
The script will collect:
### System information
<li> Kernel version </li>
<li> Active user sessions </li>
<li> Logged in users </li>
<li> Users with shell </li>

### Network information
<li> IP addresses </li>
<li> Routing table </li>
<li> Active connections </li>

### Hardware 
<li> CPU information </li>
<li> Memory usage </li>
<li> Disks and partions </li>

### Services
<li> Active systemd services </li>

### Updates
<li> Available updates </li>


## How to use
<li> Give permissions </li> 
``` 
chmod +x system_script.sh 
```
<li> Run the script </li>
```
./system_script.sh 
```

