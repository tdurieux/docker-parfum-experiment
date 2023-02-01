FROM node:12-alpine

WORKDIR /usr/src/app/

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY ./ ./

CMD ["npm", "run", "build"]