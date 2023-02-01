FROM node:14.15.5-slim

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . ./

EXPOSE 3000
ENTRYPOINT ["yarn", "start"]
