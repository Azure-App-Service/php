#!/usr/bin/env bash
# arg1: name of destination dockerhub
# arg2: dockerhub username
# arg3: dockerhub password

set -x -e

buildnumber=${4-$(date -u +"%y%m%d%H%M")}

docker login -u "$2" -p "$3"

# build base images
docker build -q -t "$1"/php:5.6.38-apache_"$buildnumber" 5.6.38-apache
docker build -q -t "$1"/php:7.0.32-apache_"$buildnumber" 7.0.32-apache
docker build -q -t "$1"/php:7.2.11-apache_"$buildnumber" -t "$1"/php:latest_"$buildnumber" 7.2.11-apache
docker tag "$1"/php:latest_"$buildnumber" "$1"/php:latest

docker push "$1"/php:5.6.38-apache_"$buildnumber"
docker push "$1"/php:7.0.32-apache_"$buildnumber"
docker push "$1"/php:7.2.11-apache_"$buildnumber"
docker push "$1"/php:latest_"$buildnumber"
docker push "$1"/php:latest

# xdebug depends on base images
# generate dockerfile for xdebug
sed -e s/reponame/"$1"/g -e s/buildnumber/"$buildnumber"/g 5.6.38-apache-xdebug/Dockerfile.template > 5.6.38-apache-xdebug/Dockerfile
sed -e s/reponame/"$1"/g -e s/buildnumber/"$buildnumber"/g 7.0.32-apache-xdebug/Dockerfile.template > 7.0.32-apache-xdebug/Dockerfile
sed -e s/reponame/"$1"/g -e s/buildnumber/"$buildnumber"/g 7.2.11-apache-xdebug/Dockerfile.template > 7.2.11-apache-xdebug/Dockerfile

# build xdebug images
docker build -q -t "$1"/php:5.6.38-apache-xdebug_"$buildnumber" 5.6.38-apache-xdebug
docker build -q -t "$1"/php:7.0.32-apache-xdebug_"$buildnumber" 7.0.32-apache-xdebug
docker build -q -t "$1"/php:7.2.11-apache-xdebug_"$buildnumber" -t "$1"/php:latest-xdebug_"$buildnumber" 7.2.11-apache-xdebug

docker push "$1"/php:5.6.38-apache-xdebug_"$buildnumber"
docker push "$1"/php:7.0.32-apache-xdebug_"$buildnumber"
docker push "$1"/php:7.2.11-apache-xdebug_"$buildnumber"
docker push "$1"/php:latest-xdebug_"$buildnumber"

docker logout
