FROM node:10.20.0-alpine
COPY package*.json ./

RUN npm install && npm cache clean --force;
RUN mkdir web
COPY . ./web
RUN cd web/server && npm install && npm cache clean --force;
RUN cd web/react-spa && npm install && npm rebuild node-sass --force && npm cache clean --force;
