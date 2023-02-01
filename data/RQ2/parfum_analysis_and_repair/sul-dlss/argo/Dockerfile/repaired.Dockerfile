FROM ruby:3.1-alpine

RUN apk add --update --no-cache \
  build-base \
  # speed up nokogiri gem installation
  libxml2-dev \
  libxslt-dev \
  # needed for mysql2 dependency
  mariadb-dev \
  # needed for sqlite dependency
  sqlite-dev \
  # rails server cannot start without tzdata
  tzdata \
  yarn

WORKDIR /app
RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN gem update --system && \
  gem install bundler && rm -rf /root/.gem;

COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries && \
  bundle config set without 'production' && \
  bundle install

RUN gem install foreman

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . .

CMD ["docker/entrypoint.sh"]
