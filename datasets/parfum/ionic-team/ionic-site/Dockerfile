FROM node:16

WORKDIR /usr/src/app

COPY package.json ./

RUN npm i

COPY . ./

EXPOSE 3000

CMD npm run start
