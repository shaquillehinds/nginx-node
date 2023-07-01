#!/bin/bash

separator="-------------------------------------------"

if [ ! -s ./nginx/.conf ] && [ ! -s ./nginx/default ]; then
  echo $separator
  echo "no nginx/default file or nginx/.conf file. Running without certbot"
  $@
  exit
fi

if [ ! -s ./nginx/default ] && [ -s ./nginx/.conf ]; then
  if bash ./build_default.sh &>log.txt; then
    echo $separator
    echo "Default built successfully"
  else
    echo $separator
    echo "Default build failed, check your .conf file. Running without certbot"
    $@
    exit
  fi
fi

$@ &>/var/log/node &
disown

cd /srv/node

if [ -s ./nginx/.conf ]; then
  . ./nginx/.conf
  echo $separator
  echo "Loading variables: email-$email port-$port"
  if [ -z "$email" ]; then email=john@doe; fi
  if [ -z "$port" ]; then
    appPort=$(grep "^\s*proxy_pass\b" ./nginx/default | cut -d ";" -f 1 | rev | cut -d ":" -f 1 | rev)
  else
    appPort=$port
  fi
else
  email=john@doe.com
  appPort=$(grep "^\s*proxy_pass\b" ./nginx/default | cut -d ";" -f 1 | rev | cut -d ":" -f 1 | rev)
fi

echo $separator
echo "Using email: $email"

crontab certbot-cron
service cron start

if [ -n "$appPort" ]; then
  retries=0
  while [ $retries -lt 24 ]; do
    echo $separator
    echo "Waiting for application to be ready on port $appPort..."
    if ss -tln | grep :$appPort &>/dev/null; then break; fi
    sleep 5s
    retries=$(($retries + 1))
  done
fi

if [ -s ./nginx/default ]; then
  cp ./nginx/default /etc/nginx/sites-available/default
  echo $separator
  echo "Nginx default config found"
  domainOpt=$(bash get_domains.sh)
  service nginx restart
  echo $separator
  echo $domainOpt
  publicPath=$(grep '^\s*root\b' ./nginx/default | cut -d ';' -f 1 | rev | cut -d ' ' -f 1 | rev)
  if [ -n "$domainOpt" ]; then
    echo $separator
    echo "Registering domain(s): $domainOpt"
    if [ -n "$publicPath" ]; then
      echo $separator
      echo "Your current public path is: $publicPath"
    fi
    certbot --nginx $domainOpt --agree-tos --email $email --non-interactive
    certbot renew --dry-run
  else
    echo $separator
    echo "No domain found"
  fi
else
  echo $separator
  echo "No default config. If you wish to use Nginx with SSL, place a folder called nginx in the root of your project and inside of it place a file named 'default' with your nginx server configuration."
fi

tail -f /var/log/node
