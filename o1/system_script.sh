#!/bin/bash
#
# This is a script to collect system information - RECON 
#
# 
# 
echo "RECON SCRIPT TO CHECK LINUX ENVIRONMENT - See log file"

# Logs to a file with timestamp
OUTPUT="system_report_$(date +%F_%H-%M-%S).txt" 
echo "" >> $OUTPUT
echo
# system info 
echo "=== SYSTEM INFO ===" >> $OUTPUT
uname -a >> $OUTPUT
who >> $OUTPUT
echo >> $OUTPUT
echo "=== CURRENT USER ===" >> $OUTPUT
echo $USER >>  $OUTPUT
echo  >> $OUTPUT

# users with shell
echo >> $OUTPUT
echo "=== USER WITH  SHELL ===" >> $OUTPUT
grep "sh$" /etc/passwd >> $OUTPUT

# network info
echo >> $OUTPUT
echo "=== NETWORK ===" >> $OUTPUT
echo "IP configuration: " >> $OUTPUT
ip a | grep inet >> $OUTPUT
echo  "routing table: " >> $OUTPUT
ip route show >> $OUTPUT
echo "active connections" >> $OUTPUT
ss -tuln >> $OUTPUT
echo "" >> $OUTPUT

echo >> $OUTPUT

# hardware info
echo "=== Hardware ===" >> $OUTPUT
echo "CPU: " >> $OUTPUT
lscpu >> $OUTPUT
echo "Memory: " >> $OUTPUT
free -h >> $OUTPUT
echo "Disks: " >> $OUTPUT
lsblk >> $OUTPUT
echo "" >> $OUTPUT

# active services
echo "=== Services ===" >> $OUTPUT
echo "Active services"  >> $OUTPUT
systemctl list-units --type=service --state=running >> $OUTPUT

# available updates
echo "=== AVAILABLE UPDATES ===" >> $OUTPUT
echo "Available updates" >> $OUTPUT
apt update 2>/dev/null
apt list --upgradable 2>/dev/null >> $OUTPUT

