FROM node:7.10.1-wheezy

MAINTAINER Peter Lai <alk03073135@gmail.com>

RUN npm install -g ganache-cli

EXPOSE 8545

CMD ganache-cli --hostname=0.0.0.0
