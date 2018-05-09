#!/usr/bin/env bash
# arg1: name of destination dockerhub
# arg2: dockerhub username
# arg3: dockerhub password

set -x -e

buildnumber=${4-$(date -u +"%y%m%d%H%M")}

docker build -q --no-cache -t "$1"/php:5.6.36-apache-xdebug_"$buildnumber" 5.6.36-apache-xdebug
docker build -q --no-cache -t "$1"/php:7.0.30-apache-xdebug_"$buildnumber" 7.0.30-apache-xdebug
docker build -q --no-cache -t "$1"/php:7.2.5-apache-xdebug_"$buildnumber" -t "$1"/php:latest-xdebug_"$buildnumber" 7.2.5-apache-xdebug

docker login -u "$2" -p "$3"

docker push "$1"/php:5.6.36-apache-xdebug_"$buildnumber"
docker push "$1"/php:7.0.30-apache-xdebug_"$buildnumber"
docker push "$1"/php:7.2.5-apache-xdebug_"$buildnumber"
docker push "$1"/php:latest-xdebug_"$buildnumber"

docker logout
