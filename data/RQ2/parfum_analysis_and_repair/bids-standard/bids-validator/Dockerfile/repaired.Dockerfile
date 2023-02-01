FROM node:14-alpine

COPY . /src

RUN npm install -g npm && npm cache clean --force;
WORKDIR /src
RUN npm install && npm cache clean --force;
RUN npm -w bids-validator run build
RUN npm -w bids-validator pack
RUN npm install -g bids-validator-*.tgz && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/bids-validator"]
