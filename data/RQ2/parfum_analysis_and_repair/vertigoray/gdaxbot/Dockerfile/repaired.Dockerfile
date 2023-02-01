FROM node:6

WORKDIR /usr/src/gdaxbot

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENV NODE_ENV production

EXPOSE 80 443

CMD [ "npm", "start" ]
