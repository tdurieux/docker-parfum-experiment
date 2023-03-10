FROM node:10-alpine

MAINTAINER OmiseGO Engineering <eng@omise.co>

WORKDIR /home/node

RUN apk add --no-cache --update \
    python \
    python-dev \
    py-pip \
    build-base \
		git

RUN git clone https://github.com/omisego/plasma-contracts.git
RUN cd /home/node/plasma-contracts && git checkout 5ce7d0b
RUN cd /home/node/plasma-contracts/plasma_framework && npm install && npm cache clean --force;
