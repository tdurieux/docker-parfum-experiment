FROM node:alpine

RUN apk add --no-cache make gcc g++ python \
  && npm config set registry https://registry.npm.taobao.org \
  && npm install -g yarn \
  && yarn config set registry https://registry.npm.taobao.org && npm cache clean --force; && yarn cache clean;

WORKDIR /app/services/service-user
COPY ./packages /app/packages
COPY ./services/service-user/package.json /app/services/service-user

RUN yarn && yarn cache clean;

COPY . /app

RUN npm run build

EXPOSE 3000

CMD npm start
