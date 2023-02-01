FROM node:16-alpine

WORKDIR /usr/proxy

# First copy over dependencies separate from src for better caching
COPY package.json yarn.lock tsconfig.json .yarnrc.yml tsup.config.ts ./
COPY .yarn ./.yarn
COPY ./packages/proxy-container/package.json ./packages/proxy-container/

WORKDIR /usr/proxy/packages/proxy-container

RUN yarn workspaces focus && yarn cache clean;

# Next up, copy over our src and build it, then prune deps for prod
COPY ./packages/proxy-container ./
RUN yarn build && yarn workspaces focus --production && yarn cache clean;

CMD ["node", "--enable-source-maps", "./dist/index.js"]
