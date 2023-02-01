FROM node:10-alpine
RUN npm install -g webpack && npm cache clean --force;
WORKDIR /usr/src/app
COPY package*.json /usr/src/app/
RUN npm install && npm cache clean --force;
EXPOSE 3000