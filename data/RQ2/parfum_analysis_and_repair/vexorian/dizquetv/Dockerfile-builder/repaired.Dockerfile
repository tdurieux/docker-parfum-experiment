FROM node:12.18-alpine3.12
WORKDIR /home/node/app
COPY package*.json ./
RUN npm install && npm install -g browserify nexe@3.3.7 && npm cache clean --force;
COPY --from=vexorian/dizquetv:nexecache /var/nexe/* /var/nexe/
COPY . .