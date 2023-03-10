# https://github.com/lewagon/rails-base-chrome-imagemagick/tree/dev
FROM quay.io/lewagon/rails-base-chrome-imagemagick:dev
ARG BUNDLER_VERSION
ENV BUNDLER_VERSION=${BUNDLER_VERSION:-2.1.4}

COPY ./Aptfile /tmp/Aptfile
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  $(cat /tmp/Aptfile | xargs) && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

ENV PATH /app/bin:$PATH

WORKDIR /app

COPY Gemfile Gemfile.lock package.json yarn.lock ./

# Upgrade RubyGems and install required Bundler version
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;
RUN gem update --system && \
  gem install bundler:$BUNDLER_VERSION && \
  bundle config set deployment 'true' && \
  bundle config set without 'development test' && \
  bundle install && rm -rf /root/.gem;

COPY app/ ./app
COPY bin/ ./bin
COPY config/ ./config
COPY lib/ ./lib
COPY db/ ./db
COPY public/ ./public
COPY config.ru Rakefile postcss.config.js babel.config.js ./
RUN mkdir log


ENV RAILS_ENV=production
ENV NODE_ENV=production

# Hack to not leak the master_key for build
# https://github.com/rails/rails/issues/32947#issuecomment-531508722
ENV ASSETS_PRECOMPILE=1
ENV SECRET_KEY_BASE=1

RUN rails assets:precompile

ENV RAILS_LOG_TO_STDOUT=enabled
ENV RAILS_SERVE_STATIC_FILES=enabled

# cleanup
RUN rm -rf node_modules tmp/cache vendor/assets test

EXPOSE 3000