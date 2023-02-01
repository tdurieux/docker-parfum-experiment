FROM node

WORKDIR /app

COPY package.json ./

RUN yarn install && yarn cache clean;

COPY . .

CMD ["yarn", "start"]