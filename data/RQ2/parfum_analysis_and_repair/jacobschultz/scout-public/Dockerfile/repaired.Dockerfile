FROM node:10-alpine

ENV NODE_ENV = "development"

USER node

WORKDIR /home/node

COPY --chown=node:node . .

RUN cp ./api/package*.json ./ && npm install && npm cache clean --force;

EXPOSE 3000

WORKDIR /home/node/api

CMD [ "node", "app.js"]