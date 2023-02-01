FROM node:boron

MAINTAINER Ivan Font <ifont@redhat.com>

# Create app directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# Clone game source code
RUN git clone https://github.com/font/pacman.git .

# Install app dependencies
RUN npm install && npm cache clean --force;

# Expose port 8080
EXPOSE 8080

# Run container
CMD ["npm", "start"]
