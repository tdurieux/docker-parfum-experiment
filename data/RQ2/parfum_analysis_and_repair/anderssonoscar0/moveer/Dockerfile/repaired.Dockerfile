FROM node:16.6.1-stretch-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
COPY config.js ./
RUN npm install --only=prod && npm cache clean --force;

# Bundle app source
COPY . .

CMD [ "node", "bot" ]
