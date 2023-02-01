FROM ubuntu:latest

# Install basics
RUN apt-get -q update && apt-get install --no-install-recommends -y -qq \
  git \
  curl \
  gcc \
  make \
  build-essential \
  software-properties-common \
  sudo \
  apt-utils \
  unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install node.js
RUN curl -f -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - \
  && apt-get install --no-install-recommends -y -q nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/adadgio/neo4j-js-ng2.git /neo4j-js-ng2

WORKDIR /neo4j-js-ng2

RUN npm install && npm cache clean --force;
RUN npm install angular-cli && npm cache clean --force;

RUN curl -f -sL https://raw.githubusercontent.com/sofwerx/swx-devops/master/aws/swx-geotools1/docker-neo4j/neo4j-js.conf > neo4j.settings.json

#RUN npm build

# http://localhost:4200

EXPOSE 4200
EXPOSE 49153
CMD npm start

