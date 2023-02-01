FROM ruby:2.7

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /umdio/
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME
RUN bundle install

ADD . $APP_HOME
