FROM node:lts-alpine
WORKDIR /repo
RUN npm install && npm cache clean --force;
CMD npm test