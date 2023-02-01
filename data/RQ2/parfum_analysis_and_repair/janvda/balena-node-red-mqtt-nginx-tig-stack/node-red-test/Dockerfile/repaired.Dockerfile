FROM nodered/node-red-docker:rpi-v8

# installing an editor
USER root
RUN apt-get update && apt-get install -y --no-install-recommends nano && rm -rf /var/lib/apt/lists/*;
USER node-red

RUN npm install node-red-contrib-resinio && npm cache clean --force;
RUN npm install node-red-dashboard && npm cache clean --force;
RUN npm install node-red-contrib-credentials && npm cache clean --force;

# install node-red-admin which is needed if you want to created hashed password for the node-red editor.
RUN sudo npm install -g --unsafe-perm node-red-admin && npm cache clean --force;

COPY ./settings.js /data/settings.js
