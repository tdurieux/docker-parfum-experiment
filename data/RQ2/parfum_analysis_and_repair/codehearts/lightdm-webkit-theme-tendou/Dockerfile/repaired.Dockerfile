FROM node:7.5.0
WORKDIR /app
COPY package.json /node/package.json
RUN npm install --prefix ../node && npm cache clean --force;
VOLUME /app
CMD npm test
