FROM node:alpine

RUN apk add --no-cache make gcc g++ python \
  && npm config set registry https://registry.npm.taobao.org \
  && npm install -g yarn \
  && yarn config set registry https://registry.npm.taobao.org && npm cache clean --force; && yarn cache clean;

WORKDIR /app/apis/api-auth
COPY ./packages /app/packages
COPY ./apis/api-auth/package.json /app/apis/api-auth

RUN yarn

COPY . /app

RUN npm run build

EXPOSE 8000

CMD npm start
