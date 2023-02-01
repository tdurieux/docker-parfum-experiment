FROM node:carbon

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

EXPOSE 80
CMD [ "npm", "start" ]