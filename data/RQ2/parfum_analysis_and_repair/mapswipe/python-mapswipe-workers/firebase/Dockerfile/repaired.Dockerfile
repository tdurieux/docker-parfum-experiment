FROM node:14-alpine
RUN npm install firebase-functions@latest firebase-admin@latest --save && npm cache clean --force;
RUN npm install -g firebase-tools && npm cache clean --force;
COPY . /firebase
RUN cd firebase/functions && npm install && npm cache clean --force;
WORKDIR /firebase/
