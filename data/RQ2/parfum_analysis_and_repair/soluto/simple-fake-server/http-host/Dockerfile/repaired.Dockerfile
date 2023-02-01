FROM node:10

WORKDIR /src

COPY package.json yarn.lock ./

RUN yarn && yarn cache clean;

COPY . .

CMD [ "yarn", "start" ]