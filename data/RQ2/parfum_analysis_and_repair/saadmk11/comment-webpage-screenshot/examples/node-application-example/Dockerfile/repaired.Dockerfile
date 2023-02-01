FROM node:latest

WORKDIR /app

COPY . .

RUN npm install && npm cache clean --force;

EXPOSE 3000

ENTRYPOINT ["node", "index.js"]
