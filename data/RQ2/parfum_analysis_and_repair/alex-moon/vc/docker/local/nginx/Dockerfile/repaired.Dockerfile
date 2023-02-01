FROM nginx:latest

RUN apt-get -y update && apt-get -y --no-install-recommends install vim less curl gnupg apt-transport-https && rm -rf /var/lib/apt/lists/*;

COPY docker/local/nginx/conf/flask.conf /etc/nginx/nginx.conf
COPY docker/local/nginx/ssl/vc.local.crt /etc/ssl/vc.local.crt
COPY docker/local/nginx/ssl/vc.local.key /etc/ssl/vc.local.key

EXPOSE 80
EXPOSE 443

WORKDIR /etc/nginx
