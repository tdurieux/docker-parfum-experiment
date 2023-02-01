FROM node:16

# Create app directory
WORKDIR /

# Bundle app source
COPY . .

# Install app dependencies
COPY package.json ./
RUN npm install && npm cache clean --force;

#Start App
CMD ["npm", "start"]