FROM node:10.8-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN npm install --silent; npm cache clean --force; exit 0

ENTRYPOINT npm start

EXPOSE 3000