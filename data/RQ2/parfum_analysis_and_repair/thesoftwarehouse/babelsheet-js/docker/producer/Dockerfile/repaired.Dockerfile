FROM node:10

WORKDIR /app

COPY package.json .

RUN npm i --production && npm cache clean --force;

COPY ./build /app/build

EXPOSE 3000

CMD npm run start-producer
