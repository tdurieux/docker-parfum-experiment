FROM node:18

WORKDIR /app

COPY package.json .
RUN npm i && npm cache clean --force;

COPY app.js .
COPY views ./views
COPY public ./public

CMD node app.js