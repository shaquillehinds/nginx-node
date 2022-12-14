FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade

RUN apt-get -y install curl

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt -y install nodejs

EXPOSE 80 443

RUN apt -y install nginx

RUN apt-get -y install python3-certbot-nginx

RUN touch /var/log/node && mkdir /srv/node

WORKDIR /srv/node

COPY nginx ./nginx

ADD entrypoint.sh build_default.sh get_domains.sh ./

RUN ["chmod", "+x", "/srv/node/entrypoint.sh"]

ENTRYPOINT [ "./entrypoint.sh" ]
