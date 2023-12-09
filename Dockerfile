FROM ubuntu:20.04

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y ca-certificates
RUN apt-get install -y curl 
RUN apt-get install -y gnupg
RUN apt-get install -y python3-certbot-nginx
RUN apt-get install -y cron
RUN apt -y install nginx

RUN mkdir /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN NODE_MAJOR=18
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.16.1 nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm install --global yarn

EXPOSE 80 443

RUN touch /var/log/node && mkdir /srv/node

WORKDIR /srv/node

COPY nginx ./nginx

ADD entrypoint.sh build_default.sh get_domains.sh certbot-cron ./

RUN ["chmod", "+x", "/srv/node/entrypoint.sh"]

ENTRYPOINT [ "./entrypoint.sh" ]
