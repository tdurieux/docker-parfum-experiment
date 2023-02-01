FROM node:10-slim

COPY . .

RUN npm install --production && npm cache clean --force;

ENTRYPOINT ["node", "/lib/main.js"]
