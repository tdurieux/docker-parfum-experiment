FROM node:latest

ENV APP_PATH=/express-app
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

RUN npm init -y
RUN npm install -y express socket.io-redis socket.io && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

COPY index.html /$APP_PATH/
COPY main.js /$APP_PATH/