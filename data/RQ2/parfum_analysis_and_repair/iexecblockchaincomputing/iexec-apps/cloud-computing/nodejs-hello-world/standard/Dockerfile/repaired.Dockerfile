FROM node:10

### install your dependencies
RUN mkdir /app && cd /app && npm install figlet@1.x && npm cache clean --force;

COPY ./src /app

ENTRYPOINT [ "node", "/app/app.js"]
