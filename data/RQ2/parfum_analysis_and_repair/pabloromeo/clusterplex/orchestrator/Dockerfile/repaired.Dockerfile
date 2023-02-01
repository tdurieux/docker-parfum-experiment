FROM node:lts-slim

LABEL maintainer="pabloromeo"

RUN apt-get update && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3500

CMD ["node", "server.js"]

