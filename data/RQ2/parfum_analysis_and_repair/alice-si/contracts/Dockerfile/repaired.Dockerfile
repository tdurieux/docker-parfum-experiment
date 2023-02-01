FROM node:8

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

# Install yarn
RUN npm install -g truffle && npm cache clean --force;

# Install other dependencies
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

ENTRYPOINT ["npm", "run", "build-and-run-dev"]