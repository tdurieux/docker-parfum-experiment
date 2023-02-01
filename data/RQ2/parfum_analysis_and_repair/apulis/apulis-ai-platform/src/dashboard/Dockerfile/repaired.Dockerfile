FROM node:12

RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

ARG registry=https://registry.npm.taobao.org
ARG disturl=https://npm.taobao.org/dist
RUN yarn config set disturl $disturl && yarn cache clean;
RUN yarn config set registry $registry && yarn cache clean;

COPY package.json yarn.lock ./
RUN yarn && yarn cache clean;

COPY . .
RUN yarn build && yarn cache clean;

EXPOSE 3081
CMD node server