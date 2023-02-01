# Specify a base image
FROM node:alpine

WORKDIR /usr/app

# Install some depenendencies
COPY ./package.json ./
RUN npm install && npm cache clean --force;
COPY ./ ./

# Default command
CMD ["npm", "start"]