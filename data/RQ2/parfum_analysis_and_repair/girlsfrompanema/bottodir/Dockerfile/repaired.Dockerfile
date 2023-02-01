FROM node:latest

WORKDIR /app

COPY package.json package.json
COPY .env .env
COPY . .

RUN npm install && npm cache clean --force;

CMD ["node", "npm start"]