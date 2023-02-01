FROM node:alpine

WORKDIR /usr/app

COPY . .

RUN npm install && npm cache clean --force;

CMD ["npm", "start"]
