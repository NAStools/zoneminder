#!/bin/bash

# Prepare proper amount of shared memory
# For H.264 cameras it may be necessary to increase the amout of shared memory
# to 2048 megabytes.
umount /dev/shm
mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=512M tmpfs /dev/shm

# Start MySQL
/usr/bin/mysqld_safe & 

# Give MySQL time to wake up
SECONDS_LEFT=120
while true; do
  sleep 1
  mysqladmin ping
  if [ $? -eq 0 ];then
    break; # Success
  fi
  let SECONDS_LEFT=SECONDS_LEFT-1 

  # If we have waited >120 seconds, give up
  # ZM should never have a database that large!
  # if $COUNTER -lt 120
  if [ $SECONDS_LEFT -eq 0 ];then
    return -1;
  fi
done

# Create the ZoneMinder database
mysql -u root < db/zm_create.sql

# Add the ZoneMinder DB user
mysql -u root -e "grant insert,select,update,delete,lock tables,alter on zm.* to 'zmuser'@'localhost' identified by 'zmpass';"

# Activate CGI
a2enmod cgi

# Activate modrewrite
a2enmod rewrite

# Restart apache
service apache2 restart

# Start ZoneMinder
/usr/local/bin/zmpkg.pl start

# Start SSHD
/usr/sbin/sshd -D
