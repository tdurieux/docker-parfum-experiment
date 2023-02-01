FROM node:6.10.2-alpine
RUN npm install -g gulp && npm cache clean --force;
WORKDIR /build
ADD . .
RUN npm install && npm cache clean --force;
