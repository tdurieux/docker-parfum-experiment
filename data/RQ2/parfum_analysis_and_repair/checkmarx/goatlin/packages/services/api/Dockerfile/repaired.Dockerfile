FROM node:10.14.1-alpine

WORKDIR /app
COPY . .
RUN npm install --production && npm cache clean --force;

CMD npm start
