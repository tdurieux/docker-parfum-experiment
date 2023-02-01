FROM node:8
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .
EXPOSE 3005

CMD ["npm","start"]