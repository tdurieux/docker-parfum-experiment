FROM node:18

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;

COPY . .
RUN yarn install && yarn cache clean;

RUN yarn build

EXPOSE 3000

CMD [ "yarn", "workspace", "@dev/web", "start:prod" ]
