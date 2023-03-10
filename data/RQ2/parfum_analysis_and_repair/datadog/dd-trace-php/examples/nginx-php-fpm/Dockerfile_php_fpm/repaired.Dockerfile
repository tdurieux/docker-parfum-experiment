FROM php:7.4-fpm

ARG DD_TRACER_VERSION

ADD https://github.com/DataDog/dd-trace-php/releases/download/${DD_TRACER_VERSION}/datadog-php-tracer_${DD_TRACER_VERSION}_amd64.deb /tmp/dd-trace.deb
RUN dpkg -i /tmp/dd-trace.deb

RUN mkdir -p /var/www/public
ADD public /var/www/public

ADD www.conf /usr/local/etc/php-fpm.d/www.conf

CMD php-fpm