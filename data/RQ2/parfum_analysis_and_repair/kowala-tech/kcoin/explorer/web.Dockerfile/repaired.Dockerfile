FROM node:latest

COPY explorer/package*.json ./

RUN npm install && npm cache clean --force;

COPY explorer/. .

EXPOSE 3000

CMD [ "node", "app.js" ]
