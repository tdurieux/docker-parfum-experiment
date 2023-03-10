FROM node:16
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY src src
EXPOSE 80
CMD node ./src/main/server.js