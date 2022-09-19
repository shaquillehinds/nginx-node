#!/bin/bash

. ./nginx/.conf
echo "retrieving domain names ..." >>log.txt
echo $domains >>log.txt
if [ -n "$domains" ]; then
  readarray -t -d "," arr < <(echo $domains)
  names=""
  for domain in ${arr[@]}; do
    names+="-d $domain "
  done
  echo "$names"
  exit 0
elif [ -n "$domain" ]; then
  echo "-d $domain"
  exit 0
fi

echo $domains >>log.txt

get_domains() {
  grep '^\s*server_name\b' ./nginx/default | cut -d ';' -f 1 | cut -d ' ' -f 1,2,3,4,5,6 | xargs
}

result=$(get_domains)

echo $result >>log.txt

get_certbot_domain_args() {
  dom=""
  for var in "$@"; do
    if [ "$var" != "server_name" ]; then
      dom+="-d $var "
    fi
  done
  echo "$dom" | xargs
}

dom=$(get_certbot_domain_args $result)
echo "$dom"
