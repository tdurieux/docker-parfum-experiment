FROM node:14.16.0-alpine3.13

WORKDIR /opt/app-root/src
RUN npm install -g knex && npm cache clean --force;
RUN apk add --no-cache dumb-init
RUN chown node:node /opt/app-root/src
USER node
COPY --chown=node:node . /opt/app-root/src
RUN yarn install --prodution=true && yarn cache clean;

CMD ["dumb-init", "node", "src/index.jsx"]
