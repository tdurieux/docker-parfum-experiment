FROM node:latest

WORKDIR /app
COPY package.json .
COPY yarn.lock .

RUN yarn install && yarn cache clean;
RUN yarn global add typescript tsc

COPY . .
ENTRYPOINT [ "yarn", "start" ]
