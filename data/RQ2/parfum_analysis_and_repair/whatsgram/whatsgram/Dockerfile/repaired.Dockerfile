FROM node:14
FROM buildkite/puppeteer:latest

# Create app directory
WORKDIR /app

# Bundle app source
COPY . .

# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

#Start App
CMD ["npm", "start"]
