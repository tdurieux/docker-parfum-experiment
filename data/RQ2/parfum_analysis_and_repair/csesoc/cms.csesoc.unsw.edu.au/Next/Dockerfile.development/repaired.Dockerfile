# pulling official base image
FROM node:16.15.0-alpine

# Setting working directory
WORKDIR /next

# exposing ports
EXPOSE 3001

# npm start