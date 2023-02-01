FROM ubuntu:trusty
MAINTAINER thejsj

# Install base packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN apt-get update
# ESSENTIALS
RUN apt-get -yq --no-install-recommends install curl git software-properties-common wget && rm -rf /var/lib/apt/lists/*;
# Node JS
RUN wget -nv bit.ly/iojs-dev -O /tmp/iojs-dev.sh
RUN bash /tmp/iojs-dev.sh
# MySQL
RUN apt-get -yq --no-install-recommends install mysql-client && rm -rf /var/lib/apt/lists/*;
# NPM
RUN npm install -g gulp bower && npm cache clean --force;
# Remove Source Lists
RUN rm -rf /var/lib/apt/lists/*

#
# Add App
#
WORKDIR /app/

ADD package.json /app/package.json
RUN npm install && npm cache clean --force;
ADD .bowerrc /app/.bowerrc
ADD bower.json /app/bower.json
RUN bower install --allow-root

ADD client /app/client
ADD server /app/server
ADD config /app/config
ADD run.sh /run.sh
RUN chmod -R 777 /run.sh
RUN chmod +x /run.sh
ADD gulpfile.js /app/gulpfile.js
RUN gulp

RUN mkdir -p /data/db

EXPOSE 80 9000 9001
WORKDIR /
ENTRYPOINT ["/run.sh"]
