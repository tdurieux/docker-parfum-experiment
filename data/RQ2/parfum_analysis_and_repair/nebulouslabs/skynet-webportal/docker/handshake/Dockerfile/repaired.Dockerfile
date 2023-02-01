FROM node:15.12.0-alpine

WORKDIR /opt/hsd

RUN apk update && apk add --no-cache bash unbound-dev gmp-dev g++ gcc make python2 git
RUN git clone https://github.com/handshake-org/hsd.git /opt/hsd
RUN npm install --production && npm cache clean --force;

ENV PATH="${PATH}:/opt/hsd/bin:/opt/hsd/node_modules/.bin"

ENTRYPOINT ["hsd"]
