FROM node:dubnium-alpine

WORKDIR /app

COPY package.json ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . ./

EXPOSE 3000

CMD ["yarn", "start"]



