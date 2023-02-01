FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# for postgres
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;

# for nokogiri
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;

# for a JS runtime
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /opt/www/
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
