FROM node:14.4.0-alpine

WORKDIR /home/app/client

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]
