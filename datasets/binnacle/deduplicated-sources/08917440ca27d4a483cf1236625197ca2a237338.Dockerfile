#++++++++++++++++++++++++++++++++++++++
# PHP application Docker container
#++++++++++++++++++++++++++++++++++++++
#
# PHP-Versions:
#  ubuntu-12.04 -> PHP 5.3         (precise)  LTS
#  ubuntu-14.04 -> PHP 5.5         (trusty)   LTS
#  ubuntu-15.04 -> PHP 5.6         (vivid)
#  ubuntu-15.10 -> PHP 5.6         (wily)
#  ubuntu-16.04 -> PHP 7.0         (xenial)   LTS
#  centos-7     -> PHP 5.4
#  debian-7     -> PHP 5.4         (wheezy)
#  debian-8     -> PHP 5.6 and 7.x (jessie)
#  debian-9     -> PHP 7.0         (stretch)
#
# Apache:
#   webdevops/php-apache-dev:5.6
#   webdevops/php-apache-dev:7.0
#   webdevops/php-apache-dev:7.1
#   webdevops/php-apache-dev:ubuntu-12.04
#   webdevops/php-apache-dev:ubuntu-14.04
#   webdevops/php-apache-dev:ubuntu-15.04
#   webdevops/php-apache-dev:ubuntu-15.10
#   webdevops/php-apache-dev:ubuntu-16.04
#   webdevops/php-apache-dev:centos-7
#   webdevops/php-apache-dev:debian-7
#   webdevops/php-apache-dev:debian-8
#   webdevops/php-apache-dev:debian-8-php7
#   webdevops/php-apache-dev:debian-9
#
# Nginx:
#   webdevops/php-nginx-dev:5.6
#   webdevops/php-nginx-dev:7.0
#   webdevops/php-nginx-dev:7.1
#   webdevops/php-nginx-dev:ubuntu-12.04
#   webdevops/php-nginx-dev:ubuntu-14.04
#   webdevops/php-nginx-dev:ubuntu-15.04
#   webdevops/php-nginx-dev:ubuntu-15.10
#   webdevops/php-nginx-dev:ubuntu-16.04
#   webdevops/php-nginx-dev:centos-7
#   webdevops/php-nginx-dev:debian-7
#   webdevops/php-nginx-dev:debian-8
#   webdevops/php-nginx-dev:debian-8-php7
#   webdevops/php-nginx-dev:debian-9
#
# HHVM:
#   webdevops/hhvm-apache
#   webdevops/hhvm-nginx
#
#++++++++++++++++++++++++++++++++++++++

FROM webdevops/php-apache-dev:ubuntu-16.04

ENV PROVISION_CONTEXT "development"

# Deploy scripts/configurations
COPY etc/             /opt/docker/etc/

RUN ln -sf /opt/docker/etc/cron/crontab /etc/cron.d/docker-boilerplate \
    && chmod 0644 /opt/docker/etc/cron/crontab \
    && echo >> /opt/docker/etc/cron/crontab \
    && ln -sf /opt/docker/etc/php/development.ini /opt/docker/etc/php/php.ini

# Configure volume/workdir
WORKDIR /app/
