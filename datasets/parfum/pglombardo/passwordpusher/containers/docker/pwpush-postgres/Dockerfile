# pwpush-postgres
FROM ruby:3.0.4

LABEL maintainer='pglombardo@hey.com'

ENV APP_ROOT=/opt/PasswordPusher
ENV PATH=${APP_ROOT}:${PATH} HOME=${APP_ROOT}
ENV DATABASE_URL=postgres://passwordpusher_user:passwordpusher_passwd@postgres:5432/passwordpusher_db

# For the latest yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Required packages
RUN apt-get update -qq && \
    apt-get install -qq -y --assume-yes build-essential apt-utils libpq-dev git curl tzdata zlib1g-dev nodejs yarn

RUN mkdir -p ${APP_ROOT}
ADD ./ ${APP_ROOT}/

WORKDIR ${APP_ROOT}
EXPOSE 5100

RUN gem install bundler

ENV RACK_ENV=production
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
RUN bundle config set without 'development private test'
RUN bundle config set deployment 'true'

RUN bundle install
RUN yarn install
RUN bundle exec rails webpacker:compile

ENTRYPOINT ["containers/docker/pwpush-postgres/entrypoint.sh"]
