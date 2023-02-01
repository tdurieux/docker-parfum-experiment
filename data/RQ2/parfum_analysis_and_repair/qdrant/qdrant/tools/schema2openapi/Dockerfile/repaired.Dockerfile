FROM node:lts-alpine

WORKDIR /app

COPY . .

RUN npm install && npm cache clean --force;

CMD ["node", "convert.js"]