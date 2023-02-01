FROM ruby:2.3.0

RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libqt4-webkit libqt4-dev xvfb && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /teki
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/tmp
WORKDIR $APP_HOME

ADD . $APP_HOME

ADD Gemfile* $APP_HOME/
ADD unicorn.rb $APP_HOME/config/unicorn.rb
RUN bundle install

EXPOSE 3000
ENV RAILS_ENV=production
CMD foreman start -f Procfile
