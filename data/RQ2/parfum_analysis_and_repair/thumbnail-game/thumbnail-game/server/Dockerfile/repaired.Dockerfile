FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENV NODE_ENV production

EXPOSE 8080
CMD [ "node", "dist/index.js" ]