FROM node:alpine

RUN apk add --no-cache make gcc g++ python \
  && npm config set registry https://registry.npm.taobao.org \
  && npm install -g yarn \
  && yarn config set registry https://registry.npm.taobao.org && npm cache clean --force; && yarn cache clean;

WORKDIR /app/scheduler
COPY ./packages /app/packages
COPY ./scheduler/package.json /app/scheduler

RUN yarn

COPY . /app

RUN npm run build

EXPOSE 3000

CMD npm start
