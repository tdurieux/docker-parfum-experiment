FROM node:latest

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm cache clean --force;
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "server.js" ]