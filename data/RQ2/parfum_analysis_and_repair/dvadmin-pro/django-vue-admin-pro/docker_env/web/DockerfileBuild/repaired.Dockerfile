FROM node:14-alpine
COPY ./web/package.json /
RUN npm install --registry=https://registry.npm.taobao.org && npm cache clean --force;
