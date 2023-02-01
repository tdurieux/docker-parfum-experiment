FROM node:10

WORKDIR /usr/src/app/react

COPY package*.json ./

RUN npm install node-sass && npm install && npm cache clean --force;

EXPOSE 3000

CMD ["npm", "start"]