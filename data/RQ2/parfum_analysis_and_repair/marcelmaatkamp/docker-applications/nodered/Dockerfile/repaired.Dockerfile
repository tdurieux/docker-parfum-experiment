FROM spants/nodered
RUN npm install -g node-red-contrib-amqp && npm cache clean --force;
