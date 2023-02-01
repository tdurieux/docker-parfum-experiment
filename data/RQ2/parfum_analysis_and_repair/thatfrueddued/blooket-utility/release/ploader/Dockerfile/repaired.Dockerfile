FROM node:17-alpine

WORKDIR /app

COPY package.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENV PORT=8080

EXPOSE 8080

CMD [ "npm", "start" ]