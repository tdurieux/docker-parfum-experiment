FROM node:18-buster-slim

WORKDIR /usr/src/app/react-ui

COPY package*.json ./

RUN npm install && npm cache clean --force;

EXPOSE 3000

COPY . .

CMD ["npm", "start"]