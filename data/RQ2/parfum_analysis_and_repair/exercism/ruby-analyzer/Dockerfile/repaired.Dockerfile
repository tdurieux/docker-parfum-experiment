FROM ruby:2.5-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add --no-cache build-base gcc wget git

RUN gem install bundler -v 2.1.4

WORKDIR /opt/analyzer

COPY . .

RUN bundle install

ENTRYPOINT ["sh", "/opt/analyzer/bin/run.sh"]
