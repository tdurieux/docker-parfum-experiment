# decking: build as makeusabrew/nodeflakes
FROM makeusabrew/zeromq

MAINTAINER Nick Payne <nick@kurai.co.uk>

RUN apt-get update
# some node modules (e.g. zmq) need python to install properly
RUN apt-get install --no-install-recommends -y software-properties-common python && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# this file will need moving to the project root for this to work!
ADD . /nodeflakes

WORKDIR /nodeflakes
# remove all node modules in case they were compiled against a
# different version of node
RUN rm -fr node_modules
# and then get a nice clean install
RUN npm install --production && npm cache clean --force;

WORKDIR /
