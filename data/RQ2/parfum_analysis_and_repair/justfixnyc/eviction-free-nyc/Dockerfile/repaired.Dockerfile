FROM node:10

RUN npm install --global gatsby-cli && npm cache clean --force;
