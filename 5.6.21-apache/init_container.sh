#!/bin/bash
service ssh start
sed -i "s/error.log/error_$WEBSITE_ROLE_INSTANCE_ID.log/g" /etc/apache2/apache2.conf 
sed -i "s/access.log/access_$WEBSITE_ROLE_INSTANCE_ID.log/g" /etc/apache2/apache2.conf
sed -i "s/{PORT}/$PORT/g" /etc/apache2/apache2.conf
mkdir /var/lock/apache2
mkdir /var/run/apache2
mkdir /var/log/apache2
touch /var/log/apache2/access_$WEBSITE_ROLE_INSTANCE_ID.log
echo "$(date) Container started" >> /var/log/apache2/access_$WEBSITE_ROLE_INSTANCE_ID.log
/usr/sbin/apache2ctl -D FOREGROUND
