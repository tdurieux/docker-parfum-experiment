FROM alpine:3.5
MAINTAINER Kontena, Inc. <info@kontena.io>

ARG DOCKER_COMPOSE_VERSION=1.11.1

RUN apk update && apk --update --no-cache add \
    tzdata ruby ruby-irb ruby-bigdecimal \
    ruby-io-console ruby-json ca-certificates libssl1.0 openssl libstdc++ \
    ruby-dev build-base openssl-dev \
    git curl py-pip

RUN gem install --no-ri --no-rdoc bundler rake
RUN pip install --no-cache-dir docker-compose==$DOCKER_COMPOSE_VERSION

ADD test/Gemfile /kontena/test/
ADD cli/Gemfile cli/kontena-cli.gemspec /kontena/cli/

# required for the gemspec
ADD cli/lib/kontena/cli/version.rb /kontena/cli/lib/kontena/cli/version.rb
ADD cli/VERSION /kontena/cli/VERSION

WORKDIR /kontena/test
RUN bundle install

RUN ln -s /kontena/cli/bin/kontena /usr/local/bin/kontena
ADD test/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
