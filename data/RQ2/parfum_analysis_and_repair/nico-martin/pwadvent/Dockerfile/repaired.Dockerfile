FROM node:12
RUN apt-get update
RUN mkdir -p /usr/src/pwadvent/node_modules && chown -R node:node /usr/src/pwadvent && rm -rf /usr/src/pwadvent/node_modules
WORKDIR /usr/src/pwadvent
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 80
CMD [ "node", "npm run prod" ]
