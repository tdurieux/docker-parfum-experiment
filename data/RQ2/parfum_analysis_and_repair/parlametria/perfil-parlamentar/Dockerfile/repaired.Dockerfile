FROM node:10-alpine

WORKDIR /app

COPY package* ./

RUN npm install && npm cache clean --force;

EXPOSE 5000

CMD npm run server