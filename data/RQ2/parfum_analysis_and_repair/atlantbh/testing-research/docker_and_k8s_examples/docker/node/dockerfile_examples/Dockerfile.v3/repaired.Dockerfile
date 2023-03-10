# Example overview:
# - creating docker image by using multi-stage build pattern (copy only what is necessary - processing file to the second stage)
FROM node:12-alpine as stage1

WORKDIR /usr/src/preprocessing

# Install "necessary" processing packages
RUN apk update
RUN apk add --no-cache git jq curl busybox-extras
RUN date > output.txt

FROM node:12-alpine as stage2

# Create app directory
WORKDIR /usr/src/app

# Do setup for running script
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;

# Multi-stage pattern - copy what is necessary to the final image
COPY --from=stage1 /usr/src/preprocessing/output.txt ./output.txt

# Copy app source
COPY . .

EXPOSE 8080
CMD [ "npm", "start" ]