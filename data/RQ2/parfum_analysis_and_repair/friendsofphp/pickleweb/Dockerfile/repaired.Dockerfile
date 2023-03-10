FROM php:5.6

RUN apt-get update -y && apt-get install --no-install-recommends -y git-core && rm -rf /var/lib/apt/lists/*;
RUN echo 'date.timezone = UTC' > /usr/local/etc/php/conf.d/date.ini

VOLUME /app
WORKDIR /app

EXPOSE 8080

ENTRYPOINT ["php"]
CMD ["-S", "0.0.0.0:8080", "-t", "web"]
