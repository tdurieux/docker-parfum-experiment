FROM node:14-alpine

COPY package.json package-lock.json index.js /
RUN npm install --production && npm cache clean --force;

CMD ["node", "index.js"]
