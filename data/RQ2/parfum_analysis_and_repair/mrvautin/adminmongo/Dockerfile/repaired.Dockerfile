FROM node:alpine
WORKDIR /app/user

COPY package.json .
RUN npm install --production && npm cache clean --force;

COPY . .
CMD node app.js
