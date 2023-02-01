FROM node:14-alpine

ENV NODE_ENV=production

WORKDIR /app
COPY package.json .
COPY yarn.lock .
RUN yarn install --production && yarn cache clean;
COPY . .
EXPOSE 3000
