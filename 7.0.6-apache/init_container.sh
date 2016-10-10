#!/bin/bash
mkdir /var/lock/apache2
mkdir /var/run/apache2
mkdir /var/log/apache2
/usr/sbin/apache2ctl -D FOREGROUND
