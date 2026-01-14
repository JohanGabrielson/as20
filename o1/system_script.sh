#!/bin/bash
#
# Detta script samlar in systeminformation - RECON
#
# Kan användas för följande attacker:
# 
echo "RECON SCRIPT TO CHECK LINUX ENVIRONMENT - See log file"

OUTPUT="system_report_$(date +%F_%H-%M-%S).txt" 
echo "" >> $OUTPUT
echo
echo "=== SYSTEM INFO ===" >> $OUTPUT
uname -a >> $OUTPUT
who >> $OUTPUT
echo >> $OUTPUT
echo "=== CURRENT USER ===" >> $OUTPUT
echo $USER >>  $OUTPUT
echo  >> $OUTPUT

echo >> $OUTPUT
echo "=== USER WITH  SHELL ===" >> $OUTPUT
grep "sh$" /etc/passwd >> $OUTPUT

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

echo "=== Hardware ===" >> $OUTPUT
echo "CPU: " >> $OUTPUT
lscpu >> $OUTPUT
echo "Memory: " >> $OUTPUT
free -h >> $OUTPUT
echo "Disks: " >> $OUTPUT
lsblk >> $OUTPUT
echo "" >> $OUTPUT

echo "=== Services ===" >> $OUTPUT
echo "Active services"  >> $OUTPUT
systemctl list-units --type=service --state=running >> $OUTPUT

echo "=== AVAILABLE UPDATES ===" >> $OUTPUT
echo "Available updates" >> $OUTPUT
apt update 2>/dev/null
apt list --upgradable 2>/dev/null >> $OUTPUT

