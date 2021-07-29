#!/usr/bin/env bash
#title            :check_logs_login.sh
#description      :This script checks logs for successful or unsuccessful attempts for SSH login (Centos and Ubuntu)
#author           :Serhii Pytliak
#date             :20210728
#version          :0.1
#==============================================================================

# Variables
logUbuntu='/var/log/auth.log'
logCentos='/var/log/secure'
logDir=/tmp/logs/$(date +%F)
logSucFile=${logDir}/success.log
logFailFile=${logDir}/failed.log

# Check log file 
if [ -e "${logUbuntu}" ]; then 
  logFile=${logUbuntu}
elif [ -e "${logCentos}" ]; then
  logFile=${logCentos}
fi

# Create log directory
__makeTmpDir() {
  if [[ -d "${logDir}" ]]; then
    echo "The directory ${logDir} already exists"
  else 
    mkdir -p ${logDir}
    echo "The directory ${logDir} has been created"
  fi
}

# Successful attempts SSH login
__successLogin() {
  grep "Accepted password" ${logFile} > ${logSucFile}
}

# Failed attempts SSH login
__failedLogin() {
  grep "Failed password" ${logFile} | grep -Ev "sudo|repeated" > ${logFailFile}
}

__makeTmpDir
__successLogin
__failedLogin
