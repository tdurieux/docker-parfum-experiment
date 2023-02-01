FROM node:10.13-alpine

WORKDIR /app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD npm start