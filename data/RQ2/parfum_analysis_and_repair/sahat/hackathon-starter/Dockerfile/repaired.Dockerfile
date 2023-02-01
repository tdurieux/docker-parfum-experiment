FROM node:12-slim

WORKDIR /starter
ENV NODE_ENV development

COPY package.json /starter/package.json

RUN npm install pm2 -g && npm cache clean --force;
RUN npm install --production && npm cache clean --force;

COPY .env.example /starter/.env.example
COPY . /starter

CMD ["pm2-runtime","app.js"]

EXPOSE 8080
