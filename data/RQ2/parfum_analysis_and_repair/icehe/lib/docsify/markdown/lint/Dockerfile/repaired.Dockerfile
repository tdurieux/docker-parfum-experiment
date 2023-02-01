# https://hub.docker.com/r/icehe/markdownlint

FROM ruby:alpine
RUN gem install mdl
RUN apk add --no-cache git
CMD ["irb"]
