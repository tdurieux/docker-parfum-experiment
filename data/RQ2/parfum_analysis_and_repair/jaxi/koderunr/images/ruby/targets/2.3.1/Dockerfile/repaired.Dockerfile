FROM ruby:2.3.1-alpine
MAINTAINER Jingkai He

ENV RUBY_PATH /ruby
RUN mkdir -p $RUBY_PATH
WORKDIR $RUBY_PATH

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]