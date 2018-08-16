#!/bin/sh

cat >/etc/motd <<EOL 
  _____                               
  /  _  \ __________ _________   ____  
 /  /_\  \\___   /  |  \_  __ \_/ __ \ 
/    |    \/    /|  |  /|  | \/\  ___/ 
\____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
A P P   S E R V I C E   O N   L I N U X

Documentation: http://aka.ms/webapp-linux
PHP quickstart: https://aka.ms/php-qs

EOL
cat /etc/motd

# Get environment variables to show up in SSH session
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

# start after openrc
(
        sleep 5
        echo "Starting SSH ..."
        rc-update add sshd
        rc-service sshd restart
) &

(
        sleep 5
        # make the socket
        mkdir -p /var/run/php && \
        touch /var/run/php/php-fpm.sock && \
        chown www-data:www-data /var/run/php/php-fpm.sock && \
        chmod 660 /var/run/php/php-fpm.sock

        echo "Starting php-fpm ..."
        rc-service php-fpm restart
) &

(
        sleep 5
        echo "Starting Nginx ..."
        rc-service nginx restart
) &

# openrc needs to start as PID 1
echo "Starting openrc ..."
exec /sbin/init 
