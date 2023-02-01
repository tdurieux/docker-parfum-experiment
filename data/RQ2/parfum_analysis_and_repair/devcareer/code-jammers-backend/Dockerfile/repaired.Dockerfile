FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

COPY .env .


EXPOSE 3000

CMD ["npm", "start"]