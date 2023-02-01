FROM ruby:2.3.0

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
ENV APP_HOME /followr
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
VOLUME $APP_HOME
EXPOSE 3000
ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
