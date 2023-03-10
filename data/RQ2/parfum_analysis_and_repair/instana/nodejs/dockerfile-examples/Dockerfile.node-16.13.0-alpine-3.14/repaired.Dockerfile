# Bare Alpine image, native addon compilation will fail.
# They will be downloaded on demand at runtime.
# See Dockerfile.node-16.13.0-alpine-3.14-with-native for a Dockerfile that will
# build native addons successfully.

FROM node:16.13.0-alpine3.14

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;
COPY . .
EXPOSE 3333
CMD [ "npm", "start" ]
