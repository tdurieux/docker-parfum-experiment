FROM node:lts-alpine

WORKDIR /api

ENV PATH /api/node_modules/.bin:$PATH

COPY package*.json ./

RUN yarn install --silent && yarn cache clean;

COPY . .

EXPOSE 8080

CMD ["yarn", "start"]
