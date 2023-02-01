FROM node:alpine

RUN apk add --no-cache make gcc g++ python \
  && npm config set registry https://registry.npm.taobao.org \
  && npm install -g yarn \
  && yarn config set registry https://registry.npm.taobao.org && npm cache clean --force; && yarn cache clean;

WORKDIR /app/apis/api-admin
COPY ./packages /app/packages
COPY ./apis/api-admin/package.json /app/apis/api-admin

RUN yarn && yarn cache clean;

COPY . /app

RUN npm run build

EXPOSE 8002

CMD npm start
