FROM node:8-alpine

EXPOSE 8080

WORKDIR /usr/src/app

COPY package.json ./
RUN npm install && npm cache clean --force;

COPY . .

CMD ["sh", "-c", "npm start" ]