### Config for nginx instance that serves hacktoberfest
FROM nginx:1.13.12-alpine
MAINTAINER web-experience@digitalocean.com

WORKDIR /home/deploy/hacktoberfest/current/public

# Copy the configuration over
COPY config/nginx/nginx-stage.conf /etc/nginx/conf.d/default.conf

RUN sed -i 's/hacktoberfest-2020/app/g' /etc/nginx/conf.d/default.conf

# Create health check