FROM node:fermium-bullseye

WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;

CMD [ "npm", "run", "start:debug" ]
