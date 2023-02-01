FROM node:8.11.4-alpine

RUN mkdir /app
WORKDIR /app

COPY package.json .
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "start"]
