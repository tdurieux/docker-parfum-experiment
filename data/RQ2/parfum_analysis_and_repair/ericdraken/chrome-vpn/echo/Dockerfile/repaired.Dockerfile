FROM node:alpine

WORKDIR /app

COPY . .

RUN npm install -g --production && npm cache clean --force;

EXPOSE 8080

USER node

CMD ["node", "./index.js"]
