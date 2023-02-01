# Dockerfile (tag: v3)
FROM node:10
RUN npm install webpack -g && npm cache clean --force;
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
WORKDIR /app
COPY . /app
EXPOSE 3000
CMD [ "node", "scripts/start.js"]
