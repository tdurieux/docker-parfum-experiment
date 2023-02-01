FROM node:carbon

MAINTAINER Counterparty Developers <dev@counterparty.io>

RUN apt update && apt install --no-install-recommends -y libzmq3-dev gcc g++ python3 build-essential && rm -rf /var/lib/apt/lists/*;


# install counterparty-indexd
RUN mkdir -p /data/indexd/
RUN mkdir /indexd
WORKDIR /indexd
COPY ./package.json /indexd

RUN echo "Using nodejs version `node --version` and npm version `npm --version`"
RUN npm install && npm cache clean --force;
COPY ./lib/* /indexd/lib/
COPY index.js /indexd

# start script
COPY ./docker/start.sh /usr/local/bin/start.sh
RUN chmod a+x /usr/local/bin/start.sh

EXPOSE 8432 18432 28432

# start indexd
CMD ["npm", "start"]
