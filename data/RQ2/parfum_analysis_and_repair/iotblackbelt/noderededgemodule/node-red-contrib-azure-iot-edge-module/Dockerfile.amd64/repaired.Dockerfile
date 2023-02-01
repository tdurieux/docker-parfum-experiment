# Use node-red official containers
FROM nodered/node-red:1.1.3-12-minimal-amd64

WORKDIR /usr/src/node-red
USER node-red

# Install the dashboard extension
RUN npm install node-red-dashboard && npm cache clean --force;

# Install Azure IoT Edge Module nodes
RUN npm install node-red-contrib-azure-iot-edge-module && npm cache clean --force;
