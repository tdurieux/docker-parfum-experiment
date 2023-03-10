FROM node:18-bullseye-slim
WORKDIR /home/node/app
COPY --chown=node:node . .

RUN yarn install && yarn cache clean;
