FROM node:boron

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

EXPOSE 3998
CMD [ "npm", "start" ]
