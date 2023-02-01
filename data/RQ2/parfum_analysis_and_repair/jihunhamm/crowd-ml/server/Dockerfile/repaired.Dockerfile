FROM node:7

# Install dependencies
RUN npm install -g firebase && npm cache clean --force;
RUN npm install -g firebase-token-generator && npm cache clean --force;
RUN npm install -g firebase-tools && npm cache clean --force;

# Content setup
WORKDIR /usr/src/app/
ENV NODE_PATH=/usr/local/lib/node_modules
