get_domains(){
  grep '^\s*server_name\b' ./nginx/default | cut -d ';' -f 1 | cut -d ' ' -f 1,2,3,4,5,6 | xargs
}

result=$(get_domains)

get_certbot_domain_args(){
  domains=""
  for var in "$@"
  do
    if [ "$var" != "server_name" ]
    then
      domains+="-d $var "
    fi
  done
  echo "$domains" | xargs
}

domains=$(get_certbot_domain_args $result)
echo "$domains"