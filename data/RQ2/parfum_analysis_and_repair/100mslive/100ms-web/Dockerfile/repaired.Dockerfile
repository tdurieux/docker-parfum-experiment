FROM node:17

WORKDIR /app

COPY package.json ./

COPY yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

ENV PORT=8080

EXPOSE 8080

CMD ["yarn", "start"]