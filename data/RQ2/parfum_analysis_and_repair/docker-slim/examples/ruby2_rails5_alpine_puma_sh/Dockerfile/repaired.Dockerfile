FROM ruby:2.6-alpine3.11

RUN apk update && apk add --no-cache build-base ruby-dev tzdata && \
		mkdir -p /opt/my/service

WORKDIR /opt/my/service
COPY service /opt/my/service

RUN bundle install

EXPOSE 1300
ENTRYPOINT ["./scripts/server.sh"]
