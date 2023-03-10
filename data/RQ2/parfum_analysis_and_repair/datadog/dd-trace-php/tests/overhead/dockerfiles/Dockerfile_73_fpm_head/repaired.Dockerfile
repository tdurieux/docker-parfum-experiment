FROM overhead-php-fpm-base

ENV TESTING_ENVIRONMENT=head

ADD ./ /dd-trace-php

WORKDIR /dd-trace-php

RUN composer update
RUN composer install-ext
RUN make generate
RUN echo "ddtrace.request_init_hook=/dd-trace-php/bridge/dd_wrap_autoloader.php" >> /usr/local/etc/php/conf.d/ddtrace.ini