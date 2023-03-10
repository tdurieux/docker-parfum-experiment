FROM ruby:3.0-alpine

ARG DB_TEST

RUN apk add --no-cache --update build-base dpkg gcompat mysql-dev postgresql-dev tzdata

# App setup
WORKDIR /usr/src/app
COPY .. .

# Setup the entrypoint script
COPY extra/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]