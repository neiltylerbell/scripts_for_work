#!/bin/bash
echo "Server Sanity Check" > /home/tyler/MaintCHK.txt
echo "Disk:" >> /home/tyler/MaintCHK.txt
df -h >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "Memory:" >> /home/tyler/MaintCHK.txt
free -m >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "Date:" >> /home/tyler/MaintCHK.txt
date >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "Users:" >> /home/tyler/MaintCHK.txt
w >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
last >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "Services:" >> /home/tyler/MaintCHK.txt
sudo netstat -nlp >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "Processes:" >> /home/tyler/MaintCHK.txt
ps -efl  >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
sudo cat /var/log/messages >> /home/tyler/MaintCHK.txt
sudo gunzip -c /var/log/messages.1.gz >> /home/tyler/MaintCHK.txt
sudo gunzip -c /var/log/messages.2.gz >> /home/tyler/MaintCHK.txt
sudo gunzip -c /var/log/messages.3.gz >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
sudo cat /var/log/secure | sed '/Connection from 204.115.117.7/,+8 d' >> /home/tyler/MaintCHK.txt
sudo gunzip -c /var/log/secure.1.gz | sed '/Connection from 204.115.117.7/,+8 d' >> /home/tyler/MaintCHK.txt
sudo gunzip -c /var/log/secure.2.gz | sed '/Connection from 204.115.117.7/,+8 d' >> /home/tyler/MaintCHK.txt
sudo gunzip -c /var/log/secure.3.gz | sed '/Connection from 204.115.117.7/,+8 d' >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
sudo yum list installed | egrep 'mysql|http|samba|java|php' >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "cron job status" >> /home/tyler/MaintCHK.txt
sudo tail /var/log/cron >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "Slow Mysql queries" >> /home/tyler/MaintCHK.txt
sudo cat /var/log/mysqld-slow.log
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "" >> /home/tyler/MaintCHK.txt
echo "Mysql Log" >> /home/tyler/MaintCHK.txt
sudo cat /var/log/mysqld.log >> /home/tyler/MaintCHK.txt
