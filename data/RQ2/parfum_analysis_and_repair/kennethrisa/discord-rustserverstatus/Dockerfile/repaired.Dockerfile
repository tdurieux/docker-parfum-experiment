FROM node:12-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY . .

CMD [ "npm", "start" ]