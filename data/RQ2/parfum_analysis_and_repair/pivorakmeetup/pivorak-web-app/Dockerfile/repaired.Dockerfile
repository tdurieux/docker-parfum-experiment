ARG RUBY_VERSION
FROM ruby:$RUBY_VERSION

ARG BUNDLER_VERSION
ARG NODE_MAJOR

RUN curl -f -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y build-essential nodejs && rm -rf /var/lib/apt/lists/*;

ENV GEM_HOME=/bundle
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && gem install bundler:$BUNDLER_VERSION && rm -rf /root/.gem;

RUN mkdir -p /app
WORKDIR /app

COPY . ./
RUN cp config/database.yml.example config/database.yml
