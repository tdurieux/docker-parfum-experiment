FROM node:14-alpine3.15

# Create app directory
WORKDIR /usr/src/server

# Install app dependencies
COPY package*.json ./
RUN npm install

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "server.js" ]
