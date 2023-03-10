FROM heroku/heroku:20-build as base

ENV PHP_BUILDPACK_VERSION v190
ENV APP /app
ENV HOME $APP
ENV HEROKU_PHP_BIN $APP/.heroku/php/bin
ENV STACK heroku-20

ADD . $APP
WORKDIR $APP

RUN mkdir -p /tmp/buildpack/php /tmp/build_cache /tmp/env
ADD https://github.com/heroku/heroku-buildpack-php/archive/$PHP_BUILDPACK_VERSION.tar.gz ./
RUN tar -xzvf $PHP_BUILDPACK_VERSION.tar.gz -C /tmp/buildpack/php --strip-components 1 && rm $PHP_BUILDPACK_VERSION.tar.gz
RUN /tmp/buildpack/php/bin/compile /app /tmp/build_cache /tmp/env

# Set up xdebug
RUN apt-get update && apt-get --assume-yes -y --no-install-recommends install php-xdebug && rm -rf /var/lib/apt/lists/*;
