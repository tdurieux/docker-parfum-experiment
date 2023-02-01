FROM node:8

WORKDIR /home/app

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3001

CMD ["npm", "start"]