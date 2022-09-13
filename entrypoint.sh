#!/bin/bash

$@ &> /var/log/node & disown

cd /srv/node

separator="-------------------------------------------"

if [[ -s ./nginx/default ]]
then
  cp ./nginx/default /etc/nginx/sites-available/default
  echo $separator
  echo "Nginx default config found"
  service nginx restart
  domain=$(grep '^\s*server_name\b' ./nginx/default | cut -d ';' -f 1 | rev | cut -d ' ' -f 1 | rev)
  publicPath=$(grep '^\s*root\b' ./nginx/default | cut -d ';' -f 1 | rev | cut -d ' ' -f 1 | rev)
  if [ ! -z $domain ]
  then
    echo $separator
    echo "Found domain in nginx default file: $domain"
    if [ ! -z $publicPath ]
    then
      echo $separator
      echo "Your current public path is: $publicPath"
    fi
    if [[ -s ./nginx/.conf ]]
    then
      echo $separator
      echo "Found .conf file"
      . ./nginx/.conf
      if [ ! -z $email ]
      then
        echo $separator
        echo "Using email: $email"
        certbot --nginx -d $domain --agree-tos --email $email --non-interactive
      else
         echo $separator
         echo "No email found in .conf file. Using john@doe.com"
         certbot --nginx -d $domain --agree-tos --email john@doe.com --non-interactive
      fi
    else
      echo $separator
      echo "No .conf file found in nginx folder. Running in non interactive mode with email: john@doe.com"
      certbot --nginx -d $domain --agree-tos --email john@doe.com --non-interactive
    fi
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