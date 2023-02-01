# Start with debian jessie
FROM debian:jessie
# Get prerequisites
RUN apt-get update && apt-get install --no-install-recommends -y \
  libcairo2-dev \
  man-db \
  nodejs \
  nodejs-legacy \
  npm && rm -rf /var/lib/apt/lists/*;
# Put the (symlinked) db in here
RUN mkdir -p /usr/src/sudoroom-data && rm -rf /usr/src/sudoroom-data
# Put the app in here
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
# Get npm stuff
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force;
# Get everything else
COPY . /usr/src/app
# Expose the port we listen on
EXPOSE 80
# Run it
CMD [ "npm", "start" ]
