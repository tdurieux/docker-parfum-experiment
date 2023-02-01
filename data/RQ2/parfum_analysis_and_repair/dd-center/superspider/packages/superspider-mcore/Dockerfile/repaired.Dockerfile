FROM node:slim
LABEL maintainer="afanyiyu@hotmail.com"
LABEL version="0.1.0"
WORKDIR /app
COPY . /app
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm i && npm cache clean --force;
RUN npm audit fix
EXPOSE 2162
ENTRYPOINT npm run start
