FROM node:12-slim

WORKDIR /app

COPY ./app ./

RUN npm install && npm cache clean --force;

COPY ./app/package*.json ./
ENV FLAG=wsc{redacted}

EXPOSE 80

CMD [ "npm", "start" ]