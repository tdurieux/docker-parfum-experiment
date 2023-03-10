# Official Node.js 8.x lts image based on Debian stretch (has ghostscript 9.20 in its archive)
FROM node:carbon-stretch

RUN apt-get update
RUN apt-get --yes --no-install-recommends install ghostscript && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install libgs-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /src

# Only copy the package.json for now
# If it didn't change this will improve build time because node_modules can be cached
# https://christianfei.com/posts/Cache-speed-up-docker-node-modules/
COPY package.json .

ENV GS4JS_HOME=/usr/lib/x86_64-linux-gnu
RUN npm install && npm cache clean --force;

# Copy the rest of the source code over
COPY . .

CMD [ "npm", "start" ]
