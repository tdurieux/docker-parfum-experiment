FROM nodered/node-red-docker
RUN npm install node-red-contrib-rdkafka && npm cache clean --force;
