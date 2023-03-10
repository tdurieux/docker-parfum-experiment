# Bare Node.js 16 image, using yarn.
# Native addons will work since the base image (Debian Buster) has all
# dependencies installed out of the box.

FROM node:16.13.0
WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn && yarn cache clean;
COPY . .
EXPOSE 3333
CMD [ "yarn", "start" ]
