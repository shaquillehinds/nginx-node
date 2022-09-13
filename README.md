# nginx-node

## Description

Simple docker base image for nginx with node

## Important Note

Make sure you have a subdomain name ready and that you have created an A record that points to the ip address of the machine you will be running the container on.

## Instructions

1. Create nginx/default and nginx/.conf files in the root of your project

```
 mkdir nginx && touch nginx/default nginx/.conf
```

1. Add your nginx server settings to the nginx/default file

```
# Example file
server {
	listen 80 default_server;
	listen [::]:80 default_server;

  # Your project root is /srv/node and your files will be served from the public folder
  # Do not change unless your public is not in the root of your project
	root /srv/node/public;

	index index.html index.htm index.nginx-debian.html;

	server_name your.domain.com;

  location / {
    proxy_pass http://localhost:4000; #whatever port your app runs on
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
}
```

3. Add your email to the nginx/.conf file so letsencrypt can update you on the status of your certificate

```
email=your@email.com
```

4. Your Dockerfile should look like this. Make sure your public folder is in the root of your project as a validation file will be placed there so letsencrypt can verify through http-01 challenge

```
FROM omegareizo/nginx-node

# The working directory is already to /srv/node
# Do not change, just copy your project files to the current directory

COPY package*.json ./

RUN npm install

COPY ./ ./

RUN npm run build

CMD ["npm", "run", "start"]
```

5. Build your image and run it on the your cloud server.
