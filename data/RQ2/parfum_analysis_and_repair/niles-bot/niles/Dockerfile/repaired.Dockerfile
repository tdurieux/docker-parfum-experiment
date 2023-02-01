FROM node:lts-alpine3.15
WORKDIR /usr/src/niles
COPY . .
RUN npm install --production && npm cache clean --force;
CMD [ "npm", "start"]