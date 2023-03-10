### First Stage ###
# Base Image
FROM node:12-slim as build
WORKDIR /usr/src/app

# Install Dependencies
COPY package*.json ./
RUN npm install && npm cache clean --force;

# Copy in the application we created
COPY . .

### Second Stage ###
FROM gcr.io/distroless/nodejs:12

# Copy App + Dependencies from Build Stage
COPY --from=build /usr/src/app /usr/src/app
WORKDIR /usr/src/app

# Set User to Non-Root
USER 1000

# Run Server
CMD [ "server.js" ]