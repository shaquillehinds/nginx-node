FROM ubuntu:20.04

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get -y install curl

# RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y ca-certificates gnupg
RUN mkdir /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN NODE_MAJOR=18
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.16.1 nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get install nodejs -y

EXPOSE 80 443

RUN apt -y install nginx

RUN apt-get -y install python3-certbot-nginx cron

RUN touch /var/log/node && mkdir /srv/node

WORKDIR /srv/node

COPY nginx ./nginx

ADD entrypoint.sh build_default.sh get_domains.sh certbot-cron ./

RUN ["chmod", "+x", "/srv/node/entrypoint.sh"]

ENTRYPOINT [ "./entrypoint.sh" ]
