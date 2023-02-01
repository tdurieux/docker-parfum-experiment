FROM ruby:2.5.9-alpine
ARG precompileassets
    RUN mkdir -p /usr/local/etc \
  && { \
    echo 'install: --no-document'; \
    echo 'update: --no-document'; \
  } >> /usr/local/etc/gemrc;

RUN apk --no-cache add --update \
    build-base \
    nodejs \
    yarn \
    tzdata \
    postgresql-dev \
    postgresql-client \
    postgresql \
    libffi \
    libxml2 \
    libxslt \
    libc6-compat \
    imagemagick && \
    gem update --system --no-document && \
    gem install bundler --no-document --force && rm -rf /root/.gem;

WORKDIR /api

COPY Gemfile* /api/
RUN bundle config set --local path /usr/local/bundle && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install

COPY package.json yarn.lock /api/
RUN yarn install && yarn cache clean;

COPY . /api

RUN scripts/potential_asset_precompile.sh $precompileassets

CMD ["scripts/server"]
