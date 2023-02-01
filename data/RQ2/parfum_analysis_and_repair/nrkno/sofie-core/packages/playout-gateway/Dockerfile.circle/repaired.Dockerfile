FROM node:16.14-alpine
RUN apk add --no-cache tzdata

COPY package.json /opt/
COPY node_modules /opt/node_modules
COPY playout-gateway /opt/playout-gateway
COPY blueprints-integration /opt/blueprints-integration
COPY server-core-integration /opt/server-core-integration

WORKDIR /opt/playout-gateway
CMD ["yarn", "start"]