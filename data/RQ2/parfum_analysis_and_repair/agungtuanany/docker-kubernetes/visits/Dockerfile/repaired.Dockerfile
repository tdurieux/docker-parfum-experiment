# Specify a base image
FROM node:alpine

WORKDIR '/app'

# install some dependencies
COPY package.json .
RUN npm install && npm cache clean --force;
COPY . .

# Default command
CMD ["npm", "start"]
