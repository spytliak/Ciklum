### Tasks for create scripts
```
- Set up an SSH client (if you don’t have one).
 - Run a Linux VM locally or on a cloud.
 - Make a script that will run every minute and check logs for successful or unsuccessful attempts for SSH login.
 - It is ok to run it from the root user.
 - Also make another script that will run on premise and count successful / unsuccessful login attempts per user.
 * Optional task. Also count how many times each user assumed root privileges.
 ** Optional task. On every login attempt or on assume root privileges post a message in Telegram. Use webhooks, an instruction to configure is here, for instance: https://gist.github.com/dideler/85de4d64f66c1966788c1b2304b9caf1. It’s ok to use a hardcoded token.
 ```

 * [check_logs_login.sh](/BASH/check_logs_login.sh) - The script checks logs for successful or unsuccessful attempts for SSH login (Centos and Ubuntu)
 * [count_login_atttempts.sh](/BASH/count_login_atttempts.sh) - The script counts successful / unsuccessful login attempts per user
 * [sudo_attempts.sh](/BASH/sudo_attempts.sh) - The script counts how many times each user assumed root privileges

 #### Examples
 The simple script check_logs_login.sh is wrote for cron. The script runs every minute and creats new log files with successful and failed  attempts for SSH login
```
[root@ops-controller1 ~]# crontab -l
* * * * * /root/check_logs_login.sh

[root@ops-controller1 ~]# ll /tmp/logs/2021-07-29/
total 8
-rw-r--r-- 1 root root 633 Jul 29 10:09 failed.log
-rw-r--r-- 1 root root 540 Jul 29 10:09 success.log
```

Output of count_login_atttempts.sh:
  ```
  [root@ops-controller1 ~]# ./count_login_atttempts.sh
=========================================================
The server name: ops-controller1
=========================================================
The log file:  /var/log/secure
=========================================================
The success attempts ssh login:
       5 root
=========================================================
The failed attempts ssh login:
       6 root
```