#!/usr/bin/env bash
#title            :count_login_atttempts.sh
#description      :This script counts successful / unsuccessful login attempts per user
#author           :Serhii Pytliak
#date             :20210729
#version          :0.1
#==============================================================================

# Variables
hostname=$(hostname)
logUbuntu='/var/log/auth.log'
logCentos='/var/log/secure'

# Check hostname
echo "========================================================="
echo "The server name: ${hostname}"

# Check log file 
if [ -e "${logUbuntu}" ]; then 
  logFile=${logUbuntu}
elif [ -e "${logCentos}" ]; then
  logFile=${logCentos}
fi
echo "========================================================="
echo -e "The log file:  $logFile"

# Count successful attempts SSH login
__successLogin() {
  grep 'Accepted password' $logFile | awk '{print $9;}' | sort | uniq -c
}
echo "========================================================="
echo -e "The success attempts ssh login:\n $(__successLogin)"

# Count failed attempts SSH login
__failedLogin() {
  grep 'Failed password' $logFile | grep -Ev "sudo|repeated" | awk '{print $9;}' | sort | uniq -c 
}
echo "========================================================="
echo -e "The failed attempts ssh login:\n $(__failedLogin) "

