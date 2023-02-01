FROM nacyot/javascript-node.js:0.10.29
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN npm install -g coffee-script && npm cache clean --force;

# Set default WORKDIR
WORKDIR /source
