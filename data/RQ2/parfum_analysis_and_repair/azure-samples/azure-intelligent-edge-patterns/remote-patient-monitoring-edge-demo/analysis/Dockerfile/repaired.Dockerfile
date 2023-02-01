FROM node:14-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install typescript -g && npm cache clean --force;
RUN npm install dotenv -g && npm cache clean --force;

RUN npm ci --only=production

COPY . .

CMD [ "npm", "run", "start:prod" ]