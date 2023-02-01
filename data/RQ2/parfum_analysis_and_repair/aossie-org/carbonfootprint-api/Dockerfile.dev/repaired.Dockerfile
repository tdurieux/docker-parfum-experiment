FROM node:10.16-alpine

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY package*.json /usr/src/app/

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

# Add your preference
CMD [ "npm", "start" ]
