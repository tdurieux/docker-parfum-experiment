# A node.js v8 box
FROM node:8

# Who(m) to blame if nothing works
#MAINTAINER nobody@nowhere.com

# Create a working directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

# Switch to working directory
WORKDIR /usr/src/app

# Copy contents of local folder to `WORKDIR`
# You can pick individual files based on your need
COPY ./api/ .

# First build, create the local .env file
#RUN cp -n .env.sample .env

# Install nodemon globally
RUN npm install -g nodemon && npm cache clean --force;

# Install dependencies (if any) in package.json
RUN npm install && npm cache clean --force;

# Expose port from container so host can access 3001
EXPOSE 3001

# Start the Node.js app on load
CMD [ "nodemon", "server.js" ]
