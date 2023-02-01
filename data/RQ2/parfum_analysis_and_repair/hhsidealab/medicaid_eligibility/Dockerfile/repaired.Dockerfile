FROM ruby:2.3

RUN apt-get update -qq && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /myapp
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME

