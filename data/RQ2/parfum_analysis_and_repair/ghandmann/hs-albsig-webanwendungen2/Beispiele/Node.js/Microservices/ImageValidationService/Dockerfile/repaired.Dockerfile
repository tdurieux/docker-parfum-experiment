FROM node:10.18.0-alpine3.9

WORKDIR /opt/ImageValidationService/

RUN apk --update --no-cache add imagemagick

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD [ "node", "app.js" ]