FROM node:latest
RUN mkdir -p /usr/src/node && rm -rf /usr/src/node
WORKDIR /usr/src/node
COPY package.json /usr/src/node/
COPY package-lock.json /usr/src/node/

RUN npm install && npm cache clean --force;
COPY . /usr/src/node
EXPOSE 9500

CMD [ "npm", "run", "game" ]