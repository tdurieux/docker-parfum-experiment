FROM node:latest

RUN mkdir -p /app
WORKDIR /app

COPY . /app

RUN yarn install --production && yarn cache clean;
RUN yarn add --dev typescript @types/node

CMD ["yarn", "run", "launch"]