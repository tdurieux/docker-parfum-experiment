FROM node:10-alpine

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/

ENV NODE_ENV production

RUN yarn install

COPY . /usr/src/app/

EXPOSE 3000

# start command
CMD [ "npx", "ts-node", "index.ts" ]