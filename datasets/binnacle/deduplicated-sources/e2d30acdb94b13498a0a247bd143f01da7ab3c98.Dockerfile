# base-image for node on any machine using a template variable
FROM resin/%%RESIN_MACHINE_NAME%%-node:6

# Defines our working directory in container
WORKDIR /usr/src/app

# Copies the package.json first for better cache on later pushes
COPY package.json package.json

# This install npm dependencies on the resin.io build server,
# making sure to clean up the artifacts it creates in order to reduce the image size.
RUN JOBS=MAX npm install --production --unsafe-perm && npm cache clean && rm -rf /tmp/*

# This will copy all files in our root to the working  directory in the container
COPY . ./

# Enable systemd init system in container
ENV INITSYSTEM on

# server.js will run when container starts up on the device
CMD ["npm", "start"]
