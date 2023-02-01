FROM node:16.15.0

WORKDIR /app
COPY ./ /app
WORKDIR /app/server
RUN yarn install && yarn cache clean;
RUN yarn build

ENTRYPOINT ["yarn", "prod:start"]
