FROM ruby:2.6.5-stretch
ENV LANG C.UTF-8

ENV RAILS_ENV=development
ENV NODE_ENV=development
ENV APP_ROOT /app
WORKDIR $APP_ROOT

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl apt-transport-https wget && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    vim \
    mysql-client \
    yarn \
    nodejs && \
    gem install bundler && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT
RUN bundle install
RUN bundle exec rails assets:precompile

COPY . $APP_ROOT

EXPOSE 3000