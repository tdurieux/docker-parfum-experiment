FROM node:12
WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./

RUN yarn install && yarn cache clean;

COPY . .

RUN yarn build && yarn cache clean;

EXPOSE 5014

CMD [ "yarn", "build:start" ]
