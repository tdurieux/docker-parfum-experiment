FROM mhart/alpine-node:11.10.1

RUN apk update && apk add --no-cache --virtual build-dependencies git python g++ make
RUN yarn global add truffle@5.0.1 && yarn cache clean;
RUN yarn global add ganache-cli@6.4.1 && yarn cache clean;

RUN mkdir -p /deploy/money-market
WORKDIR /deploy/money-market

# First add deps
ADD ./package.json /deploy/money-market/
ADD ./yarn.lock /deploy/money-market/
RUN yarn && yarn cache clean;

# Then rest of code and build
ADD . /deploy/money-market

RUN truffle compile

RUN apk del build-dependencies
RUN yarn cache clean && yarn cache clean;

CMD while :; do sleep 2073600; done
