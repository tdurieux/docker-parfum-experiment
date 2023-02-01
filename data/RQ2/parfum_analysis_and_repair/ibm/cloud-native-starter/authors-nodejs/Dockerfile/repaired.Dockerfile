FROM node:8-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

# Set permissions
RUN chmod -R 777 /usr/src/app

# Server listens on
EXPOSE 3000

CMD ["npm", "start"]
