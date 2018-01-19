#!/usr/bin/env bash
set -x -e

buildnumber=${4-$(date -u +"%y%m%d%H%M")}

# docker build -t "$1"/php:5.6.21-apache_"$buildnumber" 5.6.21-apache
# docker build -t "$1"/php:5.6.21-apache-xdebug_"$buildnumber" 5.6.21-apache-xdebug
# docker build -t "$1"/php:7.0.6-apache_"$buildnumber" 7.0.6-apache
# docker build -t "$1"/php:7.0.6-apache-xdebug_"$buildnumber" 7.0.6-apache-xdebug
# docker build -t "$1"/php:7.2.1-apache_"$buildnumber" -t "$1"/php:latest_"$buildnumber" 7.2.1-apache
docker build -t "$1"/php:7.2.1-apache-xdebug_"$buildnumber" -t "$1"/php:latest-xdebug_"$buildnumber" 7.2.1-apache-xdebug

docker login -u "$2" -p "$3"

# docker push "$1"/php:5.6.21-apache_"$buildnumber"
# docker push "$1"/php:5.6.21-apache-xdebug_"$buildnumber"
# docker push "$1"/php:7.0.6-apache_"$buildnumber"
# docker push "$1"/php:7.0.6-apache-xdebug_"$buildnumber"
docker push "$1"/php:latest_"$buildnumber"
docker push "$1"/php:7.2.1-apache_"$buildnumber"
docker push "$1"/php:latest-xdebug_"$buildnumber"
docker push "$1"/php:7.2.1-apache-xdebug_"$buildnumber"

docker logout
