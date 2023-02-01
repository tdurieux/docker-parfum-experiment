FROM node:latest

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

CMD ["node","index.js"]