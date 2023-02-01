FROM node:15-slim

ENV NODE_ENV=production

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean;

# Bundle app source
COPY . .

EXPOSE 3000
CMD [ "node", "app.js" ]