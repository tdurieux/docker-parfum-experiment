# Create image based on the Node image from dockerhub
FROM node:latest

# set DOCKERIZED
ENV DOCKERIZED=true

# Create a directory where our app will be placed
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

# Change directory so that our commands run inside this new directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package.json /usr/src/app

# Install dependecies
RUN npm install && npm cache clean --force;

# Get all the code needed to run the app
COPY . /usr/src/app

# Build app sources
RUN npm run build

# Expose the port the app runs in
EXPOSE 80

# Serve the app
CMD ["npm", "start"]
