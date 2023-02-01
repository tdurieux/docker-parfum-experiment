FROM node:12-alpine

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

# Copy app source
COPY . /usr/src/app

CMD [ "npm", "start" ]
