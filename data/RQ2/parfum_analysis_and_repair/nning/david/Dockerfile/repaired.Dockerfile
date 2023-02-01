FROM ruby:alpine

EXPOSE 5683/udp

COPY . /app
WORKDIR /app

RUN \
  apk update && \
  apk add --no-cache build-base && \
  bundle install --without development test && \
  apk del build-base && \
  rm /var/cache/apk/*.gz

CMD rackup
