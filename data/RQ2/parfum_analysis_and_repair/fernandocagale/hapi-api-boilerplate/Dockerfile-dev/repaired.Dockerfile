# Set the base image to Ubuntu
FROM node:6.10

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

# Default dir
WORKDIR /usr/src/app

# Install nodemon
RUN npm install -g nodemon && npm cache clean --force;

# Copy package
COPY package.json /usr/src/app/

# Install app dependencies
RUN npm cache clean --force && npm install --silent --progress=false && npm cache clean --force;

# Bundle app source
COPY . /usr/src/app

# Expose port
EXPOSE  8080

# Run app using nodemon
CMD ["nodemon", "/usr/src/app/server.js"]
