FROM --platform=linux/arm nodered/node-red:1.0.2

RUN npm install node-red-contrib-influxdb \
                node-red-node-serialport \
                node-red-dashboard && npm cache clean --force;
