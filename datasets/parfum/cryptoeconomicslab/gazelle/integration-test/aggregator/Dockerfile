FROM node:10.18.1
WORKDIR /HOME

# prepare dependency
COPY . /HOME/gazelle
WORKDIR /HOME/gazelle
RUN npm i
RUN npm run bootstrap
RUN npm run build

# start aggregator process
WORKDIR /HOME/aggregator
COPY ./integration-test/aggregator .
RUN cp -n .sample.env .env

RUN npm i
RUN npm run build

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

CMD dockerize -wait tcp://ganache:8545 -wait tcp://postgres:5432 npm start
