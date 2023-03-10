FROM node:8

RUN git clone https://github.com/lacker/coinkit.git

# TODO: put this somewhere else
RUN mkdir /hostfiles

WORKDIR /coinkit/ts

RUN npm install && npm cache clean --force;

ENTRYPOINT ../testnet/hserver-entrypoint.sh

# Proxy
EXPOSE 3000

# Tracker
EXPOSE 4000
