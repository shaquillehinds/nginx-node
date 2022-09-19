# Simple docker base image for nginx with node

## Important Note

Make sure you have a subdomain name(s) ready and that you have created an A record that points to the ip address of the machine you will be running the container on.

## Instructions

1. Create nginx/.conf file in the root of your project OR create nginx/default server file if you're comfortable with nginx. Project structure should look like this, the default file is optional and it will override the .conf file if it is present:

```
your_project
  \_nginx/
    \_ default
    \_ .conf
  \_ public/
  \_ ...
```

2. Add your nginx server settings to the nginx/.conf file or if you want fine control settings use the nginx/default file. See example in this repo if you need reference.

3. Add your email to the nginx/.conf file so letsencrypt can update you on the status of your certificate. See reference file nginx/.conf.example

4. Your Dockerfile should look similar to the Dockerfile.example in this repo. Make sure your public folder is in the root of your project as a validation file will be placed there so letsencrypt can verify through http-01 challenge. If your public folder is anywhere else but the root of your project then you must specify in the .conf or default file.

5. Build your image and run it on the your cloud server.
