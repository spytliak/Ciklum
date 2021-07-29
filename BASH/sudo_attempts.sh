#!/usr/bin/env bash
#title            :sudo_attempts.sh
#description      :This script counts how many times each user assumed root privileges
#author           :Serhii Pytliak
#date             :20210729
#version          :0.1
#==============================================================================

# Variables
userListLogin=$(awk -F: '$2 != "*" && $2 !~ /^!/ { print $1; }' /etc/shadow)
userSudoList=$(getent group sudo | cut -d: -f4 |sed 's/,/\n/g')

# Check all users who can login, and check root privileges
__userListCanLogin() {
    echo -e "The list of ssh users: \n ${userListLogin}"
    echo -e "The list of users with root privileges: \n ${userSudoList}"
}
__userListCanLogin


 

# Example log with sudo output
# Jul 26 06:45:42 ps sudo:       ps : TTY=pts/0 ; PWD=/home/ps ; USER=root ; COMMAND=/usr/bin/date
