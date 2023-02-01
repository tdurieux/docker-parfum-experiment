#Require Node.js12
FROM node:12-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY * ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 3000
CMD node cloudgate.js -r ./apps/CatchAll