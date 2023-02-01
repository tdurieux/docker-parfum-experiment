FROM node:alpine
CMD yarn dev
WORKDIR /app
COPY package*.json ./
RUN yarn install && yarn cache clean;
# npm config set scripts-prepend-node-path true &&
# COPY . .