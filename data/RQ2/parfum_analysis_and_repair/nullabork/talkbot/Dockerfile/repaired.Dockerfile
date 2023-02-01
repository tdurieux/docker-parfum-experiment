FROM python:2.7
LABEL Name="Talkbotv12"
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# make sure apt is up to date
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y curl build-essential libssl-dev libprotobuf-dev protobuf-compiler cmake && rm -rf /var/lib/apt/lists/*;

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.13.0

RUN mkdir -p $NVM_DIR
# Install nvm with node and npm
RUN curl -f https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm config set python python2.7
RUN npm config set msvs_version 2015

RUN npm install pm2 -g && npm cache clean --force;
RUN npm install node-gyp -g && npm cache clean --force;

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN chmod +x /usr/src/app/command.sh

RUN npm install && npm cache clean --force;
RUN npm rebuild