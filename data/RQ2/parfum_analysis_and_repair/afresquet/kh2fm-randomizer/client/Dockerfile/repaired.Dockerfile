FROM node:17-alpine

WORKDIR /app

COPY package*.json .

RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
