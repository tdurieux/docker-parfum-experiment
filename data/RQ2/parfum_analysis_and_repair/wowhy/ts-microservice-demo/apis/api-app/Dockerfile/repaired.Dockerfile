FROM node:alpine

RUN apk add --no-cache make gcc g++ python \
  && npm config set registry https://registry.npm.taobao.org \
  && npm install -g yarn \
  && yarn config set registry https://registry.npm.taobao.org && npm cache clean --force; && yarn cache clean;

WORKDIR /app/apis/api-app
COPY ./packages /app/packages
COPY ./apis/api-app/package.json /app/apis/api-app

RUN yarn && yarn cache clean;

COPY . /app

RUN npm run build

EXPOSE 8001

CMD npm start
