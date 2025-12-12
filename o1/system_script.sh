#!/bin/bash
#
# Detta script samlar in systeminformation - RECON
#
# Kan användas för följande attacker:
# [Skriv möjliga attacker]
#
# Author: Frans Schartau
# Last Update: 2025-01-01

echo "RECON SCRIPT FÖR ATT KONTROLLERA LINUXMILJÖ - Se loggfil"

OUTPUT="system_report_$(date +%F_%H-%M-%S).txt" 
echo "" >> $OUTPUT
echo
echo "=== SYSTEMINFO ===" >> $OUTPUT
uname -a >> $OUTPUT
who >> $OUTPUT
echo >> $OUTPUT
echo "=== AKTUELL ANVÄNDARE ===" >> $OUTPUT
echo $USER >>  $OUTPUT
echo  >> $OUTPUT

echo >> $OUTPUT
echo "=== ANVÄNDARE MED SHELL ===" >> $OUTPUT
grep "sh$" /etc/passwd >> $OUTPUT

echo >> $OUTPUT
echo "=== NÄTVERK ===" >> $OUTPUT
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

