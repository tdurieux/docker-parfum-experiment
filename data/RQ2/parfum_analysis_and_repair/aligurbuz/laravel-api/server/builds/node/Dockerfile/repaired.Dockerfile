# install latest node
# https://hub.docker.com/_/node/
FROM node:latest
RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

# create and set app directory
RUN mkdir -p /usr/src/app/ && rm -rf /usr/src/app/
WORKDIR /usr/src/app/

# install app dependencies
# this is done before the following COPY command to take advantage of layer caching
RUN npm install && npm cache clean --force;
RUN npm i pm2 -g && npm cache clean --force;
CMD ["pm2-runtime", "server.js"]