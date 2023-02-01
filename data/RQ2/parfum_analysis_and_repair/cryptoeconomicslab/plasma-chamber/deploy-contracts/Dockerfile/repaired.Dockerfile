FROM node:8.15.1-alpine AS builder

RUN npm i lerna yarn truffle@4.1.15 -g && npm cache clean --force;
RUN apk add --no-cache python python3 make g++ zeromq-dev curl git
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir vyper==0.1.0b9

COPY packages packages
COPY package.json package.json
COPY lerna.json lerna.json
COPY yarn.lock yarn.lock

RUN npm_config_user=root npm i -g zmq && npm cache clean --force;
RUN lerna bootstrap \
&& cd packages/contracts \
&& yarn build

FROM node:8.15.1-alpine
COPY --from=builder node_modules node_modules
COPY --from=builder packages/contracts packages/contracts
COPY deploy-contracts/wait.sh wait.sh
RUN apk add --no-cache curl
RUN npm i truffle@4.1.15 -g && npm cache clean --force;
CMD ["/bin/ash"]