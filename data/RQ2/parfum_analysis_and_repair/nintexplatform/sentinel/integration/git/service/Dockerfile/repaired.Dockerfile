FROM node:12

COPY index.js /index.js
COPY package.json /package.json

RUN npm install && npm cache clean --force;

CMD ["node", "/index.js"]
