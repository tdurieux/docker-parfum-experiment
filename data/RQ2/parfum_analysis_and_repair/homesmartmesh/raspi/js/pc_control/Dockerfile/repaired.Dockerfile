FROM node:12
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY pc.js .
COPY mqtt.js .
COPY logger.js .
COPY config.json .
CMD [ "node", "pc.js" ]