# latest official node image
FROM node:8.12.0

# base packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y
RUN apt-get install --no-install-recommends -y libusb-1.0-0 libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;

# process management
RUN npm i -g pm2 && npm cache clean --force;

# use cached layer for node modules
ADD package.json /tmp/package.json
RUN cd /tmp && npm install --unsafe-perm && npm cache clean --force;
RUN mkdir -p /usr/src/app && cp -a /tmp/node_modules /usr/src/app/ && rm -rf /usr/src/app

# add project files
ADD . /usr/src/app
ADD package.json /usr/src/app/package.json
WORKDIR /usr/src/app

# run app
CMD pm2 start process.yml
