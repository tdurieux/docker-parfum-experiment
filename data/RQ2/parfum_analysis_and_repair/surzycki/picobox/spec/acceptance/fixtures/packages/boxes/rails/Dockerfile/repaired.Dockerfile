# picobox for use with rails containing ruby and nodejs
#
# VERSION               0.1.0

# Change this for different versions of ruby (see https://hub.docker.com/_/ruby/)
# FROM ruby:2.2-slim
# FROM ruby:2.3-slim

FROM ruby:slim-stretch
MAINTAINER Stefan Surzycki <stefan.surzycki@gmail.com>

ENV APP_HOME /var/www
ENV PATH $APP_HOME/bin:$PATH

# silence deb warnings
ENV DEBIAN_FRONTEND noninteractive
ENV HOSTNAME picobox

# do install here
RUN mkdir -p /tmp
WORKDIR /tmp

# add repository software
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential software-properties-common tzdata wget curl gnupg2 && rm -rf /var/lib/apt/lists/*;

## Languages

# nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;


## Database dependencies

# postgres client
RUN apt-get install --no-install-recommends -y libpq-dev postgresql-client && rm -rf /var/lib/apt/lists/*;

# sql-lite
RUN apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# mysql
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;


# Tools

## phantomjs pre-requisites
RUN apt-get install --no-install-recommends -y chrpath libssl-dev libxft-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libfreetype6 libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libfontconfig1 libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;

# phantomjs latest
RUN npm -g install phantomjs-prebuilt && npm cache clean --force;

# install yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# utils
RUN apt-get install --no-install-recommends -y nano git && rm -rf /var/lib/apt/lists/*;

# make nano work
RUN echo "export TERM=xterm" >> /etc/bash.bashrc

# working dir
WORKDIR $APP_HOME

# add gemfile
ONBUILD ADD Gemfile* $APP_HOME/

# hook up source
ONBUILD ADD . $APP_HOME