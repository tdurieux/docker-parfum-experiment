FROM node:lts-alpine

RUN apk add --no-cache bash
RUN apk add --no-cache git

RUN mkdir /game_portal_client
WORKDIR /game_portal_client

ADD src ./src
ADD public/ ./public
ADD package.json ./
ADD vue.config.js ./
ADD babel.config.js ./

RUN npm install && npm cache clean --force;

CMD ["npm", "run", "serve"]
