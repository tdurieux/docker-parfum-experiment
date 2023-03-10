# This Dockerfile can be used to update dependencies and re-export
# packages-lock.json back to the host so that they can be commited to revision
# control. To use:
# docker build . -f Dockerfile-update-deps -t updater:latest
# docker create -it --name updater updater:latest
# docker cp updater:/app/package-lock.json .
# docker rm updater
# docker rmi updater:latest
FROM node:10

WORKDIR /app

COPY package.json /app/
COPY package-lock.json /app/

# Install dependencies
RUN npm install && npm cache clean --force;
