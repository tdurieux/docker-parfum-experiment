FROM node:11-alpine

RUN npm i axios ethers fs && npm cache clean --force;

COPY src/index.js /index.js

ENTRYPOINT ["node", "/index.js"]