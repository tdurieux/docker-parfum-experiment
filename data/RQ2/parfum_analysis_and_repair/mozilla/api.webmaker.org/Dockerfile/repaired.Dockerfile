# Webmaker API

FROM ubuntu:14.04.2
MAINTAINER Mozilla Foundation <cade@mozillafoundation.org>

# install curl and native postgre bindings
RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  libpq-dev && rm -rf /var/lib/apt/lists/*;

# Install nodejs 0.12.x PPA
RUN curl -f -sL https://deb.nodesource.com/setup_0.12 | sudo bash -

# install nodejs v0.12.x
RUN apt-get update && apt-get install --no-install-recommends -y \
  nodejs && rm -rf /var/lib/apt/lists/*;

# create webmaker user and directory
RUN useradd -d /webmaker -m webmaker
USER webmaker
WORKDIR /webmaker

# Add webmaker-api source code and dependencies
ADD . /webmaker

# Set Default env
RUN cp env.sample .env

# Expose default webmaker-api port
EXPOSE 2015

# Command to execute when starting Webmaker API
CMD ["node","server"]
