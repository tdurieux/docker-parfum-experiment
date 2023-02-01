FROM node:latest as build

WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . ./

ENV NODE_ENV=production
CMD ["yarn", "run", "start"]
