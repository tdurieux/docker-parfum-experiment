FROM node:slim AS build
WORKDIR /app
COPY . /app
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm i && npm cache clean --force;
RUN npm audit fix
EXPOSE 8001 9003
ENTRYPOINT npm run start
