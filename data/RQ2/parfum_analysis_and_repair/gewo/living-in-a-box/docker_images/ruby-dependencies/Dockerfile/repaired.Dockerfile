# Ruby/Rails Dependencies (gewo/ruby-dependencies)
FROM gewo/rvm
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen'\
    | tee /etc/apt/sources.list.d/10gen.list

RUN apt-get update

# Nokogiri
RUN apt-get install --no-install-recommends -y libyaml-dev libxml2 libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*;

# RMagick system dependencies
RUN apt-get install --no-install-recommends -y libmagickwand5 libmagickwand-dev imagemagick && rm -rf /var/lib/apt/lists/*;

# ExecJS Runtime
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# MySQL gem dependencies and client
RUN apt-get install --no-install-recommends -y libmysqlclient-dev mysql-client-5.6 && rm -rf /var/lib/apt/lists/*;

# Headless Selenium Tests
RUN apt-get install --no-install-recommends -y firefox xvfb && rm -rf /var/lib/apt/lists/*;

# Java Runtime (for Solr, ...)
RUN apt-get install --no-install-recommends -y openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*;

# Install MongoDB Clients
ENV MONGODB_VERSION 2.4.6
RUN apt-get install --no-install-recommends -y mongodb-10gen=${MONGODB_VERSION} && rm -rf /var/lib/apt/lists/*;

# Redis Client
RUN apt-get install --no-install-recommends -y redis-tools && rm -rf /var/lib/apt/lists/*;

# Postgres Client and libs
RUN apt-get install --no-install-recommends -y libgmp10-dev libpq-dev postgresql-client && rm -rf /var/lib/apt/lists/*;

# Unzip
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean
