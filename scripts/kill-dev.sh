#!/bin/bash

docker ps -f ancestor=omegareizo/nginx-node:dev -q | xargs docker kill
