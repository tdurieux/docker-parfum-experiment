FROM node:12-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

RUN apk add --no-cache --virtual build-dependencies python --update py-pip \
    build-base python-dev make automake autoconf libtool \
    && pip install --no-cache-dir --upgrade pip

RUN mkdir -p /usr/src/SLPDB && rm -rf /usr/src/SLPDB

WORKDIR /usr/src

ADD . /usr/src/SLPDB
WORKDIR /usr/src/SLPDB
RUN npm i && npm cache clean --force;

COPY ./regtest/slpdb/.env.regtest .env
COPY ./regtest/slpdb/filters.regtest.yml filters.yml
COPY ./regtest/slpdb/docker-entrypoint.sh ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "run" ]
