FROM ruby:<ruby-version>-alpine

ARG BUNDLER_VERSION

# Install system dependencies
RUN apk --update --no-cache add less bash git curl wget build-base && \
    apk add --no-cache postgresql-client && \
    apk add --no-cache nodejs yarn && \
    apk add --no-cache vim imagemagick && \
    rm -rf /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log

ENV LANG=C.UTF-8

# Configure bundler
#   https://bundler.io/v2.1/guides/bundler_docker_guide.html
ENV GEM_HOME=/bundle
ENV PATH /app/bin:$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# Upgrade RubyGems and install required Bundler version
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && \
    gem install bundler:$BUNDLER_VERSION && rm -rf /root/.gem;

# Create a directory for the app code
RUN mkdir -p /app

WORKDIR /app
