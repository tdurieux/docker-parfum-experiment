FROM php:5.6-cli
MAINTAINER SportArchive, Inc.

RUN echo "date.timezone = UTC" >> /usr/local/etc/php/conf.d/timezone.ini
RUN apt-get update \
    && apt-get install --no-install-recommends -y zlib1g-dev \
    && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;

COPY . /usr/src/cloudprocessingengine
WORKDIR /usr/src/cloudprocessingengine
RUN apt-get update \
    && apt-get install --no-install-recommends -y git \
    && make \
    && apt-get purge -y git \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/src/cloudprocessingengine/bootstrap.sh"]
