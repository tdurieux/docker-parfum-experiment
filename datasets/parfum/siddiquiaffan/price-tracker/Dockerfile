FROM node:16

# Create app directory
WORKDIR /

# Bundle app source
COPY . .

# Install app dependencies
COPY package.json ./
RUN npm install

#Start App
CMD ["npm", "start"]