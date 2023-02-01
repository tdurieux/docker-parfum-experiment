FROM node:16.15-alpine3.15

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 8080

CMD ["npm","run","start"]