FROM node:10.16-alpine

# Create app directory
RUN mkdir -p /usr/src/client && rm -rf /usr/src/client
WORKDIR /usr/src/client

COPY package*.json /usr/src/client/
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /usr/src/client

# Add your preference
CMD [ "npm", "start" ]
