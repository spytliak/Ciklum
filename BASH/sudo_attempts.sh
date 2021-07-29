#!/usr/bin/env bash
#title            :sudo_attempts.sh
#description      :This script counts how many times each user assumed root privileges
#author           :Serhii Pytliak
#date             :20210728
#version          :0.1
#==============================================================================


# Check all users who can login
cat /etc/passwd |grep bash |awk -F':' '{ print $1}'

# Check root privileges
 getent group sudo | cut -d: -f4 |sed 's/,/\n/g'



Jul 26 06:45:42 ps sudo:       ps : TTY=pts/0 ; PWD=/home/ps ; USER=root ; COMMAND=/usr/bin/date
