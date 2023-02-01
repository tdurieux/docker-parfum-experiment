FROM ruby:2.6.2-alpine3.9
RUN apk update && apk add --no-cache build-base postgresql-dev postgresql-client tzdata
ADD . /app
WORKDIR /app
RUN bundle install
EXPOSE 3000
ENTRYPOINT ["/bin/sh", "production.sh"]
