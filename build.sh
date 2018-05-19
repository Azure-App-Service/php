#!/usr/bin/env bash
# arg1: name of destination dockerhub
# arg2: dockerhub username
# arg3: dockerhub password

set -x -e

buildnumber=${4-$(date -u +"%y%m%d%H%M")}

docker build -q --no-cache -t "$1"/php:5.6.36-apache_"$buildnumber" 5.6.36-apache
docker build -q --no-cache -t "$1"/php:7.0.30-apache_"$buildnumber" 7.0.30-apache
docker build -q --no-cache -t "$1"/php:7.2.5-apache_"$buildnumber" -t "$1"/php:latest_"$buildnumber" 7.2.5-apache
docker tag "$1"/php:latest_"$buildnumber" "$1"/php:latest

docker login -u "$2" -p "$3"

docker push "$1"/php:5.6.36-apache_"$buildnumber"
docker push "$1"/php:7.0.30-apache_"$buildnumber"
docker push "$1"/php:7.2.5-apache_"$buildnumber"
docker push "$1"/php:latest_"$buildnumber"
docker push "$1"/php:latest

docker logout
