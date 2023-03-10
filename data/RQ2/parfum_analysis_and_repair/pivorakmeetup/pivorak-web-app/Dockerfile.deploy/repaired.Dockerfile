ARG RUBY_VERSION=2.6.5
FROM ruby:$RUBY_VERSION
LABEL maintainer Bohdan Varshchuk <bohdan@teamvoy.com>

ARG BUNDLER_VERSION=2.1.0
ARG NODE_MAJOR=12
ARG DEBIAN_FRONTEND=noninteractive

RUN curl -f -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -
RUN /bin/sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 10.6" > /etc/apt/sources.list.d/pgdg.list'
RUN /bin/sh -c 'wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -'

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client-10 \
  build-essential nodejs locales cron iputils-ping net-tools libpq-dev \
  tmux vim less  && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app

COPY s6 /
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-amd64.tar.gz /app/tmp/
RUN tar xzf /app/tmp/s6-overlay-amd64.tar.gz -C / && rm /app/tmp/s6-overlay-amd64.tar.gz

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait

ENV GEM_HOME=/app/data/shared/bundle
ENV BUNDLE_BIN=/app/data/shared/bundle/bin
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV PATH=$BUNDLE_BIN:$PATH
ENV RAILS_ENV=production
ENV RACK_ENV=production
# ENV WAIT_HOSTS="redis:6379, postgres:5432"
ENV S6_KEEP_ENV="1"
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && gem install bundler:$BUNDLER_VERSION && rm -rf /root/.gem;

COPY ./docker-entrypoint.deploy.sh /
RUN chmod +x /docker-entrypoint.deploy.sh
RUN chmod +x /usr/local/sbin/*

COPY . ./

ENTRYPOINT ["/docker-entrypoint.deploy.sh"]
