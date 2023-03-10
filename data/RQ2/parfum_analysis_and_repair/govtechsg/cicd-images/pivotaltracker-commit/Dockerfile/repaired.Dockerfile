FROM ruby:2.4.9-alpine3.10

RUN apk add --no-cache git
COPY ./version-info /usr/bin
COPY ./commit.rb /

ENTRYPOINT [ "ruby", "commit.rb" ]