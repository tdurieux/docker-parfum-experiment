FROM node:14
RUN apt-get update && apt-get install --no-install-recommends -y build-essential libbluetooth-dev && rm -rf /var/lib/apt/lists/*;
ADD . node-bluetooth-serial-port
WORKDIR node-bluetooth-serial-port
RUN npm install --unsafe-perm && npm cache clean --force;
