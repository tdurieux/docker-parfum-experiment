FROM nginx:alpine

COPY frontend/index.html docker-compose.yml /usr/share/nginx/html/
COPY frontend/css/bootstrap.min.css frontend/css/bootstrap.min.css.map /usr/share/nginx/html/css/
COPY frontend/js/rstworkbench.js frontend/js/js-yaml.min.js /usr/share/nginx/html/js/
COPY frontend/img/preview.png /usr/share/nginx/html/img/

ARG DOMAIN

RUN sed -i "s/localhost/$DOMAIN/g" /usr/share/nginx/html/js/rstworkbench.js