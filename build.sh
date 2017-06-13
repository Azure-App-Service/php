#!/usr/bin/env bash
set -x -e

docker build -t "$1"/php:5.6.21-apache-2 -t "$1"/php:5.6-apache-2 -t "$1"/php:5-apache-2 5.6-apache
docker build -t "$1"/php:5.6.21-apache-xdebug-2 -t "$1"/php:5.6-apache-xdebug-2 -t "$1"/php:5-apache-xdebug-2 5.6-apache-xdebug
docker build -t "$1"/php:7.0.6-apache-2 -t "$1"/php:7.0-apache-2 -t "$1"/php:7-apache-2 -t "$1"/php:latest 7.0-apache
docker build -t "$1"/php:7.0.6-apache-xdebug-2 -t "$1"/php:7.0-apache-xdebug-2 -t "$1"/php:7-apache-xdebug-2 7.0-apache-xdebug

docker login -u "$2" -p "$3"

docker push "$1"/php:5.6.21-apache-2
docker push "$1"/php:5.6-apache-2
docker push "$1"/php:5-apache-2 

docker push "$1"/php:5.6.21-apache-xdebug-2
docker push "$1"/php:5.6-apache-xdebug-2
docker push "$1"/php:5-apache-xdebug-2

docker push "$1"/php:7.0.6-apache-2
docker push "$1"/php:7.0-apache-2
docker push "$1"/php:7-apache-2 
docker push "$1"/php:latest 

docker push "$1"/php:7.0.6-apache-xdebug-2
docker push "$1"/php:7.0-apache-xdebug-2
docker push "$1"/php:7-apache-xdebug-2 

docker logout