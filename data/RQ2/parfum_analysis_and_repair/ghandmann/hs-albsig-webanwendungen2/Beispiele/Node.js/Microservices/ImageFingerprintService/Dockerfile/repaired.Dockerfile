FROM node:10.18.0-alpine3.9

WORKDIR /opt/ImageFingerprintService/

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "app.js" ]