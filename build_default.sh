#!/bin/bash

echo "Building default file..."

if [ ! -s nginx/.conf ]; then
  echo "No .conf file found. Exiting build"
  exit 0
fi

. nginx/.conf

cp nginx/default.template nginx/default

if [ -z "$public" ]; then public="public"; fi

sed "s/<public>/\/srv\/node\/$public/" nginx/default &>nginx/default.tmp
mv nginx/default.tmp nginx/default

echo "public updated"

if [ -z "$domains" ]; then exit 1; fi
if [ -z "$port" ]; then exit 1; fi

domains=$(sed "s/,/ /g" <(echo $domains))

echo $domains

sed "s/<domains>/$domains/" nginx/default &>nginx/default.tmp
mv nginx/default.tmp nginx/default

sed "s/<port>/$port/" nginx/default &>nginx/default.tmp
mv nginx/default.tmp nginx/default

if [ -n $locations ]; then
  rm nginx/location 2>/dev/null
  touch nginx/location
  readarray -t -d "," arr < <(echo $locations)
  echo $arr
  for location in ${arr[@]}; do
    locationPort=$(cut -d "/" -f 1 <(echo $location))
    locationRoute=$(cut -d "/" -f 2 <(echo $location))
    echo " " >>nginx/location
    echo "  location /$locationRoute {" >>nginx/location
    echo "    proxy_pass http://localhost:$locationPort;" >>nginx/location
    echo "    proxy_http_version 1.1;" >>nginx/location
    echo "    proxy_set_header Upgrade \$http_upgrade;" >>nginx/location
    echo "    proxy_set_header Connection 'upgrade';" >>nginx/location
    echo "    proxy_set_header Host \$host;" >>nginx/location
    echo "    proxy_cache_bypass \$http_upgrade;" >>nginx/location
    echo "  }" >>nginx/location
  done
else locations=" "; fi

defaultFile=$(cat nginx/default)
location=$(cat nginx/location)

echo "${defaultFile/<locations>/$location}" >nginx/default

cat nginx/default
