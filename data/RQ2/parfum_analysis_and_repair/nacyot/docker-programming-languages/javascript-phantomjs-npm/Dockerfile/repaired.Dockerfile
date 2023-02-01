FROM nacyot/javascript-node.js:0.10.29
MAINTAINER Daekwon Kim <propellerheaven@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev libfontconfig1-dev && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g phantomjs && npm cache clean --force;

# Set default WORKDIR
WORKDIR /source
