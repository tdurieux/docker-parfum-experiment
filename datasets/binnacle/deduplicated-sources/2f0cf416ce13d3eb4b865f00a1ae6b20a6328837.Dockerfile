# 
# Dockerfile for building the node red image.
#

# build the node red image using the offical node red distribution
FROM nodered/node-red-docker:latest

# To avoid SSL certification issue
ENV NODE_TLS_REJECT_UNAUTHORIZED=0

# add the influxDB connector
RUN npm install node-red-contrib-influxdb

# add The Things Network connector
#RUN npm install node-red-contrib-ttn
RUN npm install node-red-contrib-ttn


# copy the settings file
USER node-red
COPY settings.js /usr/src/node-red/.node-red/

# change the startup command to be sure to use our settings.
CMD ["npm", "start", "--", "--userDir", "/data", "--settings", "/usr/src/node-red/.node-red/settings.js"]

# end of file

