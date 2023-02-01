FROM node:10

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install --save sleep && npm cache clean --force;
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 8080
CMD [ "node", "latency.js" ]