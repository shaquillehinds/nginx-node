# Simple docker base image for nginx with node

## Important Note

Make sure you have a subdomain name(s) ready and that you have created an A record that points to the ip address of the machine you will be running the container on.

## Instructions

1. Create nginx/default and nginx/.conf files in the root of your project. E.g

```
 mkdir nginx && touch nginx/default nginx/.conf
```

2. Add your nginx server settings to the nginx/default file. See example in this repo if you need reference.

3. Add your email to the nginx/.conf file so letsencrypt can update you on the status of your certificate. E.g

```
email=your@email.com
```

4. Your Dockerfile should look similar to the Dockerfile.example in this repo. Make sure your public folder is in the root of your project as a validation file will be placed there so letsencrypt can verify through http-01 challenge.

5. Build your image and run it on the your cloud server.
