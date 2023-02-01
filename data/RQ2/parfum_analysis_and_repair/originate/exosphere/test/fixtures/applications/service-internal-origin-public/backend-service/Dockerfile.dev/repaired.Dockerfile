FROM node:8.5.0

WORKDIR /

COPY package.json .
RUN yarn && yarn cache clean;

WORKDIR /mnt
COPY . .
