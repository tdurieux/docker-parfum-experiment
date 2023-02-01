FROM node:lts-alpine

RUN npm install -g http-server && npm cache clean --force;

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

ARG VUE_APP_API_URL
ENV VUE_APP_API_URL $VUE_APP_API_URL

COPY . .

RUN npm run build

EXPOSE 8080
CMD [ "http-server", "dist" ]