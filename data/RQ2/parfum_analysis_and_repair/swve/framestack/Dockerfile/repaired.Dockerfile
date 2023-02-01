FROM node:latest

EXPOSE 8080 3000

RUN mkdir /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY . .

RUN npm install && npm run build && npm cache clean --force;

CMD npm run start
