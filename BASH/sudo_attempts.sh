#!/usr/bin/env bash
#title            :sudo_attempts.sh
#description      :This script counts how many times each user assumed root privileges
#author           :Serhii Pytliak
#date             :20210729
#version          :0.1
#==============================================================================

# TODO
# Check all users who can login and root privileges
# Grep sudo from log 

# Check all users who can login, example command
cat /etc/passwd |grep bash |awk -F':' '{ print $1}'

# Check root privileges, example command
 getent group sudo | cut -d: -f4 |sed 's/,/\n/g'

# Example log with sudo output
Jul 26 06:45:42 ps sudo:       ps : TTY=pts/0 ; PWD=/home/ps ; USER=root ; COMMAND=/usr/bin/date
