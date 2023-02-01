FROM node:latest

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN yarn install && yarn cache clean;

# Bundle app source
COPY . /usr/src/app

EXPOSE 8080
CMD [ "npm", "run", "dev" ]
