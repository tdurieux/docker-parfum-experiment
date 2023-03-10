FROM ruby:latest
USER root

RUN curl -f https://deb.nodesource.com/setup_12.x | bash
RUN curl -f https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs yarn postgresql-client && rm -rf /var/lib/apt/lists/*;
ENV APP_PATH=/rails-app
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock
RUN bundle install
RUN rails new sample --force --no-deps --database=postgresql
COPY database.yml $APP_PATH/sample/config/database.yml
