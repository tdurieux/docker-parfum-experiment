FROM node:carbon-alpine

WORKDIR /app
COPY package.json /app
RUN npm install && npm cache clean --force;
COPY . /app

CMD ["node", "dist/server.js"]
