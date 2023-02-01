FROM ubuntu:xenial
MAINTAINER open-intent.io

ENV LD_LIBRARY_PATH="/usr/local/lib:/usr/lib/x86_64-linux-gnu"

#nodejs
RUN apt-get update; apt-get install -y nodejs npm \
        libboost-system1.58 \
        libboost-regex1.58 \
        libboost-log1.58

RUN npm install -g open-intent

RUN ln -s /usr/bin/nodejs /usr/bin/node


WORKDIR /usr/src

RUN open-intent project create chatbot
