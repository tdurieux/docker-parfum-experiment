FROM yannickburon/clouder:nginx
MAINTAINER Yannick Buron yannick.buron@gmail.com

RUN apk add --no-cache --update certbot
#RUN letsencrypt-auto certonly --help --agree-tos
