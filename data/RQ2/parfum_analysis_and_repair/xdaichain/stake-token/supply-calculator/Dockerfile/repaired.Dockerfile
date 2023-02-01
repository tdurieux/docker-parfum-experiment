FROM node:12-alpine

WORKDIR /supply-calculator
COPY package.json index.js ./
RUN npm install && npm cache clean --force;

CMD npm start