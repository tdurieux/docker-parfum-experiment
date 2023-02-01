FROM node:11.14.0-alpine
WORKDIR /usr/src/app
COPY . /usr/src/app
RUN npm i && npm cache clean --force;
RUN npm run build
RUN npm test