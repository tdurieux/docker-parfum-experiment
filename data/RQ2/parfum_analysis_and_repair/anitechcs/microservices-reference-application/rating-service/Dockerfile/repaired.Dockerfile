FROM node:12-alpine

WORKDIR /app

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080

CMD [ "node", "index.js" ]