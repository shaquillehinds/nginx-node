#!/bin/bash

. version.txt

inc="1"

newVersion=$(($version + $inc))
tag="v-8.0.1"

docker build --platform linux/x86_64 -t nginx-node:latest .
docker build --platform linux/x86_64 -t nginx-node:$tag .

docker tag nginx-node:latest omegareizo/nginx-node:latest
docker tag nginx-node:$tag omegareizo/nginx-node:$tag

docker push omegareizo/nginx-node:latest
docker push omegareizo/nginx-node:$tag

echo "version=$newVersion" >|./version.txt
