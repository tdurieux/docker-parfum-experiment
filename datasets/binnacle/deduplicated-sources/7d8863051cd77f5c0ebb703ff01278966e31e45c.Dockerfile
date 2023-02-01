FROM debian:jessie

MAINTAINER Yahya ERTURAN <root@yahyaerturan.com>

RUN apt-get update && apt-get install -y \
    nginx

ADD nginx.conf /etc/nginx/
ADD symfony.conf /etc/nginx/sites-available/
ADD cpanel.conf /etc/nginx/sites-available/
ADD clinic_ci3.conf /etc/nginx/sites-available/
ADD symfony4tutorial.conf /etc/nginx/sites-available/
ADD clinicSMF4.conf /etc/nginx/sites-available/
ADD doktor_bul.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony
RUN ln -s /etc/nginx/sites-available/cpanel.conf /etc/nginx/sites-enabled/cpanel
RUN ln -s /etc/nginx/sites-available/clinic_ci3.conf /etc/nginx/sites-enabled/clinic_ci3
RUN ln -s /etc/nginx/sites-available/symfony4tutorial.conf /etc/nginx/sites-enabled/symfony4tutorial
RUN ln -s /etc/nginx/sites-available/clinicSMF4.conf /etc/nginx/sites-enabled/clinicSMF4
RUN ln -s /etc/nginx/sites-available/doktor_bul.conf /etc/nginx/sites-enabled/doktor_bul
RUN rm /etc/nginx/sites-enabled/default

RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

CMD ["nginx"]

EXPOSE 80
EXPOSE 443
