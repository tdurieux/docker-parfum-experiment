FROM node

RUN npm install -g write-good && npm cache clean --force;