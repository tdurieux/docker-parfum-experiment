FROM node:10

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

CMD [ "npm", "run", "start" ]
