FROM node:6.11

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json .

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 3000
