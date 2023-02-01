FROM ruby:2.6.6-stretch

# Install project dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential \
  libpq-dev \
  postgresql-client \

  openjdk-8-jre \

  libxml2-dev \
  libxslt1-dev \

  redis-server \
  cron \
  vim && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler --version 2.1.4 --force

# Add the waiting script for postgre starting
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN chmod +x /wait

# Define project home
ENV APP_HOME /docker_build
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install project dependencies
ADD Gemfile* $APP_HOME/
RUN bundle install

# Add project sources
ADD . $APP_HOME/

# Add config and entrypoint
COPY config/docker/database.yml config/
COPY ./config/docker/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
