FROM nodered/node-red

RUN npm install node-red-dashboard && npm cache clean --force;
