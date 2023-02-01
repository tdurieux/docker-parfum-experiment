FROM node:10

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

COPY server.js server.js
EXPOSE 3002
CMD ["node", "server.js"]
