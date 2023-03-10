# Example overview:
# - needed some processing packages to generate some output for the app
# - creating docker image without using multi-stage build pattern
FROM node:12-alpine

# Create app directory
WORKDIR /usr/src/app

# Install "necessary" processing packages
RUN apk update
RUN apk add --no-cache git jq curl busybox-extras
RUN date > output.txt

# Do setup for running script
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;

# Copy app source
COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]