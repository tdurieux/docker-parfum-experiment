# API
FROM node:12
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .
EXPOSE 4000
CMD ["yarn", "api:dev"]

# Bot
FROM node:12
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;
COPY . .
CMD ["yarn", "bot:prod"]

