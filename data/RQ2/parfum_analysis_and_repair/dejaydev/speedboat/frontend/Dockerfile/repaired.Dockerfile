FROM node:14

WORKDIR /opt/frontend

COPY package.json yarn.lock /opt/frontend/
RUN yarn && yarn && yarn cache clean;

COPY . .
