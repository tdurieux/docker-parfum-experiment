FROM node:latest

WORKDIR /usr/src/app/

COPY package.json ./
RUN npm install --silent --no-cache && npm cache clean --force;

COPY ./ ./


CMD ["npm", "run", "start"]
