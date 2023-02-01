FROM node:16.14.2-alpine

RUN mkdir -p /app

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD ["yarn", "start:dev"]
