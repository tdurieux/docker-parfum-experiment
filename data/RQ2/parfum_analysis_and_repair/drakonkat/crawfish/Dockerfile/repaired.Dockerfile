FROM node:16.8.0
WORKDIR /usr/src
RUN git clone https://gitlab.com/tndsite/webtorrent-web-gui-standalone.git
WORKDIR /usr/src/webtorrent-web-gui-standalone/
RUN rm ./package-lock.json
RUN npm install && npm cache clean --force;
RUN npm run build-local

#APP
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install -g node-pre-gyp && npm cache clean --force;
RUN npm install && npm cache clean --force;
COPY . .
RUN cp -R ../webtorrent-web-gui-standalone/build ./public/

EXPOSE 3000
CMD [ "npm", "run", "prod" ]
