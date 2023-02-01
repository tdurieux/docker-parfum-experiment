FROM node:17

WORKDIR /app

COPY package*.json ./

RUN yarn install --production && yarn cache clean;

COPY . .

CMD ["yarn", "run", "start"]