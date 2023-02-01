FROM node:14-alpine

WORKDIR /app
COPY package*.json ./

RUN apk add --no-cache libxml2 libxslt git imagemagick python3 make g++
RUN npm install && npm cache clean --force;

COPY . .

RUN npx grunt prepare

EXPOSE 8080

CMD ["node", "server.js"]

