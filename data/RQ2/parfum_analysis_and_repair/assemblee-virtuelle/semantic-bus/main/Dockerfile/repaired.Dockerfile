# set the base image to Debian
# https://hub.docker.com/_/debian/
FROM debian:latest

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# define app folder
WORKDIR /data/main

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && apt-get install --no-install-recommends -y gcc \
    && apt-get install --no-install-recommends -y make \
    && apt-get install --no-install-recommends -y build-essential \
    && apt-get install --no-install-recommends -y ca-certificates \
    && apt-get install --no-install-recommends -y git \
    && apt-get install --no-install-recommends -y python \
    && apt-get -y autoclean && rm -rf /var/lib/apt/lists/*;


# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.13.0

# install nvm
# https://github.com/creationix/nvm#install-script
RUN mkdir -p $NVM_DIR
RUN curl -f --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.1/install.sh | bash

# install node and npm
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# add node_modules binaries to PATH (nodejs look for node_modules in parent directories)
ENV PATH /data/node_modules/.bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

RUN npm install pm2 -g && npm cache clean --force;
RUN npm install nodemon -g && npm cache clean --force;

# install and cache app dependencies
ADD ./main/package.json /data/
RUN cd /data/ && npm cache clean --force && npm install --loglevel verbose && npm cache clean --force;

# Bundle app source
ADD ./core /data/core/
ADD ./main /data/main/

ADD ./wait-for-it.sh /data/scripts/

EXPOSE 8080

CMD [ "pm2-runtime", "app.js", "--name" ,"main"]
