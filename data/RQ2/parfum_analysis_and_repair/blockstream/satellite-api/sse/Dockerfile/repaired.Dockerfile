FROM node:16-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

CMD [ "npm", "start" ]
