FROM node:16.14-alpine

WORKDIR /app

COPY . .
RUN yarn install && yarn cache clean;

CMD ["yarn", "dev"]
