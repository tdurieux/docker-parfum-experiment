FROM node:8.9.4-alpine

RUN mkdir -p /usr/src/blog_service && rm -rf /usr/src/blog_service

ADD . /usr/src/blog_service

RUN npm install -g yarn && npm cache clean --force;

RUN yarn config set registry 'https://registry.npm.taobao.org' && yarn cache clean;

RUN yarn install && yarn cache clean;

WORKDIR /usr/src/blog_service

EXPOSE 8000