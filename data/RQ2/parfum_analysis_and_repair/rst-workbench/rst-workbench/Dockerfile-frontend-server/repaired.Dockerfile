FROM nginx:stable-alpine-perl

ARG DOMAIN

COPY frontend/index.html docker-compose.yml /etc/nginx/html/
COPY frontend/css/bootstrap.min.css frontend/css/bootstrap.min.css.map /etc/nginx/html/css/
COPY frontend/js/rstworkbench.js frontend/js/js-yaml.min.js /etc/nginx/html/js/
COPY frontend/img/preview.png /etc/nginx/html/img/
COPY nginx.conf /etc/nginx/nginx.conf

RUN sed -i "s/const setupType = 'local'/const setupType = 'server'/g" /etc/nginx/html/js/rstworkbench.js && \
    sed -i "s/const hostName = 'localhost'/const hostName = '$DOMAIN'/g" /etc/nginx/html/js/rstworkbench.js