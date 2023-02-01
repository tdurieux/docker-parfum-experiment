#Mute build
FROM node:14-alpine AS builder

WORKDIR /app
# Copying only necessary files for the build. 
#(.dockerignore file contains the files or folder to exclude from the COPY statement)
COPY . ./
RUN apk add --no-cache git
RUN apk add --no-cache bash
RUN npm ci
RUN npm run build

#Launch Mute