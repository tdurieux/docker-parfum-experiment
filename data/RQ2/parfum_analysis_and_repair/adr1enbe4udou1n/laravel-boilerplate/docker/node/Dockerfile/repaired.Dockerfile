FROM node:10.12.0-alpine

# Create app directory
RUN mkdir -p /app
WORKDIR /app

# Install app dependencies
COPY package.json /app/
RUN npm install webpack -g && npm cache clean --force;
RUN npm install webpack-cli -g && npm cache clean --force;
RUN npm install webpack-dev-server -g && npm cache clean --force;
RUN npm install rimraf -g && npm cache clean --force;

CMD [ 'node' ]
