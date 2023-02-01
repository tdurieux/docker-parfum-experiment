FROM ruby:2.5

ENV APP_HOME /app
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME/
RUN bundle install