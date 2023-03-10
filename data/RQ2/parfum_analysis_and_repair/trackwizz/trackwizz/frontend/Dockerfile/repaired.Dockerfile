FROM node:12.13-alpine

WORKDIR /usr/app

COPY package*.json ./
RUN yarn install && yarn cache clean;

COPY . .

EXPOSE 3000

CMD ["yarn", "start"]
