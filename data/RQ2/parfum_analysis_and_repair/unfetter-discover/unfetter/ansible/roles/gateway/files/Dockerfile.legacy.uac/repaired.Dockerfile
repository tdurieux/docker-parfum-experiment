FROM nginx:1.13.5-alpine

LABEL maintainer "unfetter"
LABEL Description="Nginx server with compiled unfetter ui files"

COPY ./ui-dist/prod-ff31 /etc/nginx/html