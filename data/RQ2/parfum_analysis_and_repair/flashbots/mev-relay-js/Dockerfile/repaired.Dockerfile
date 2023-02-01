FROM node:14

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

EXPOSE 18545
EXPOSE 9090

CMD [ "yarn", "run", "start"]
