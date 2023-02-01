FROM node:16.15.1-stretch-slim

WORKDIR /app/

COPY package.json ./

COPY yarn.lock ./

COPY . .

RUN yarn install --frozen-lockfile && yarn cache clean;

RUN yarn build

RUN yarn install --production && yarn cache clean;

CMD [ "yarn", "start" ]
