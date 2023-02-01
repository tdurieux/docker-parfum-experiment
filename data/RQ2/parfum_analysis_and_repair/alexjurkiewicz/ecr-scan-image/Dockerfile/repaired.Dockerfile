FROM node:12-alpine as builder

COPY package.json package-lock.json /
RUN npm install && npm cache clean --force;

COPY index.js /

CMD [ "node", "/index.js" ]
