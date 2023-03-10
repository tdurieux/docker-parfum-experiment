FROM node:9

ARG relay_port

WORKDIR /relay

COPY package.json .
RUN yarn install && yarn cache clean;

COPY relay.js .

EXPOSE $relay_port

CMD ["node", "relay.js"]

