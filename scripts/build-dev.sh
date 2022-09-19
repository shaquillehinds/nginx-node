#!/bin/bash

if [ "$1" = "dev" ] || [ "$2" = "dev" ]; then
  docker build -f Dockerfile.dev -t omegareizo/nginx-node:dev .
else
  docker build -t omegareizo/nginx-node:dev .
fi
