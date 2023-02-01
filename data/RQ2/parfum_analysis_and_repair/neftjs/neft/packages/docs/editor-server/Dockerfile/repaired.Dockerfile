FROM node:10.15.3-slim

ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm install && npm cache clean --force;
ADD index.js index.js

ENTRYPOINT ["npm", "start"]
