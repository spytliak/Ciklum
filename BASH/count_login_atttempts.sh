#!/usr/bin/env bash
#title            :count_login_atttempts.sh
#description      :This script counts successful / unsuccessful login attempts per user
#author           :Serhii Pytliak
#date             :20210728
#version          :0.1
#==============================================================================

# Variables
hostname=$(hostname)
logUbuntu='/var/log/auth.log'
logRhel='/var/log/secure'


# Check hostname
echo "========================================================="
echo "The server name: ${hostname}"

# Check $1
if [[ -n $1 ]];
then
  logFile=$1
  echo Using Log file : $logFile
fi

# Check log file 
if [ -e "${logUbuntu}" ]; then 
  logFile=${logUbuntu}
elif [ -e "${logRhel}" ]; then
  logFile=${logRhel}
fi
echo "========================================================="
echo -e "The log file:  $logFile"

# Count successful attempts SSH login
__successLogin() {
  grep "Accepted password" ${logFile} | awk '{print $9;}' | sort | uniq -c
}
echo "========================================================="
echo -e "The success attempts ssh login:\n $(__successLogin)"

# Count failed attempts SSH login
__failedLogin() {
  grep "Failed password" ${logFile} | grep -Ev "sudo|repeated" | awk '{print $9;}' | sort | uniq -c
}
echo "========================================================="
echo -e "The failed attempts ssh login:\n $(__failedLogin) "



success=$(grep "Accepted" $AUTHLOG | awk '{print $9;}' | sort | uniq -c)
failed=$(grep "Failed" $AUTHLOG | awk '{print $9;}' | sort | uniq -c)


Jul 25 16:22:01 ps sshd[1152]: Accepted password for ps from 10.0.2.2 port 64612 ssh2
grep "Accepted" $AUTHLOG | awk '{print $9;}' | sort | uniq -c

Jul 25 19:45:52 ps sshd[2051]: Failed password for root from 10.0.2.2 port 55911 ssh2
grep "Failed" $AUTHLOG | awk '{print $9;}' | sort | uniq -c


MYPATH=/var/log/auth.log
tuser=$(egrep "Accepted|Failed" $MYPATH | wc -l)
suser=$(grep "Accepted password" $MYPATH | wc -l)
fuser=$(grep "Failed password" $MYPATH | wc -l)
scount=$(grep "Accepted" $MYPATH | awk '{print $9;}' | sort | uniq -c)
fcount=$(grep "Failed" $MYPATH | awk '{print $9;}' | sort | uniq -c)
echo "--------------------------------------------"
echo "Number of Users logged on System: $tuser"
echo "Successful logins attempt: $suser"
echo "Failed logins attempt: $fuser"
echo "--------------------------------------------"
echo -e "Success User Details:\n $scount"
echo "--------------------------------------------"
echo -e "Failed User Details:\n $fcount"
echo "--------------------------------------------"


--------------------------------------------
Number of Users logged on System: 8
Successful logins attempt: 2
Failed logins attempt: 6
--------------------------------------------
Success User Details:
       1 ps
      1 serhii
--------------------------------------------
Failed User Details:
       2 ps
      2 root
      1 serhii
      1 times:
--------------------------------------------




# Collect the failed login attempts
FAILED_LOG=/tmp/failed.$$.log
egrep "Failed pass" $LOG_FILE > $FAILED_LOG 

# Collect the successful login attempts
SUCCESS_LOG=/tmp/success.$$.log
egrep "Accepted password|Accepted publickey|keyboard-interactive" $LOG_FILE > $SUCCESS_LOG

# extract the users who failed
failed_users=$(cat $FAILED_LOG | awk '{ print $(NF-5) }' | sort | uniq)

# extract the users who successfully logged in
success_users=$(cat $SUCCESS_LOG | awk '{ print $(NF-5) }' | sort | uniq)
# extract the IP Addresses of successful and failed login attempts
failed_ip_list="$(egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" $FAILED_LOG | sort | uniq)"
success_ip_list="$(egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" $SUCCESS_LOG | sort | uniq)"

# Print the heading
printf "%-10s|%-10s|%-10s|%-15s|%-15s|%s\n" "Status" "User" "Attempts" "IP address" "Host" "Time range"

# Loop through IPs and Users who failed.

for ip in $failed_ip_list;
do
  for user in $failed_users;
    do
    # Count failed login attempts by this user from this IP
    attempts=`grep $ip $FAILED_LOG | grep " $user " | wc -l`

    if [ $attempts -ne 0 ]
    then
      first_time=`grep $ip $FAILED_LOG | grep " $user " | head -1 | cut -c-16`
      time="$first_time"
      if [ $attempts -gt 1 ]
      then
        last_time=`grep $ip $FAILED_LOG | grep " $user " | tail -1 | cut -c-16`
        time="$first_time -> $last_time"
      fi
      HOST=$(host $ip 8.8.8.8 | tail -1 | awk '{ print $NF }' )
      printf "%-10s|%-10s|%-10s|%-15s|%-15s|%-s\n" "Failed" "$user" "$attempts" "$ip"  "$HOST" "$time";
    fi
  done
done

for ip in $success_ip_list;
do
  for user in $success_users;
    do
    # Count successful login attempts by this user from this IP
    attempts=`grep $ip $SUCCESS_LOG | grep " $user " | wc -l`

    if [ $attempts -ne 0 ]
    then
      first_time=`grep $ip $SUCCESS_LOG | grep " $user " | head -1 | cut -c-16`
      time="$first_time"
      if [ $attempts -gt 1 ]
      then
        last_time=`grep $ip $SUCCESS_LOG | grep " $user " | tail -1 | cut -c-16`
        time="$first_time -> $last_time"
      fi
      HOST=$(host $ip 8.8.8.8 | tail -1 | awk '{ print $NF }' )
      printf "%-10s|%-10s|%-10s|%-15s|%-15s|%-s\n" "Success" "$user" "$attempts" "$ip"  "$HOST" "$time";
    fi
  done
done

rm -f $FAILED_LOG
rm -f $SUCCESS_LOG