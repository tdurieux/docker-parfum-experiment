FROM node:14

WORKDIR /app

ADD lerna.json .
ADD package.json .
ADD yarn.lock .

# Build cache layer
RUN yarn --ignore-scripts && yarn cache clean;

ADD . .

# Install any package specific dependencies
RUN yarn && yarn cache clean;

WORKDIR /app/packages/nouns-bots

RUN yarn build && yarn cache clean;

CMD [ "node",  "/app/packages/nouns-bots/dist/index.js"]
