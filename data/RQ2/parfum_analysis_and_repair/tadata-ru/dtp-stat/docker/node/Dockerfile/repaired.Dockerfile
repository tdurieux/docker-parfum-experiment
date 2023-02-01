FROM node

RUN npm install -g npx && npm cache clean --force;

WORKDIR /app
