FROM ubuntu:15.04

# Install Nodejs, npm, git and ffmpeg

RUN apt-get update && apt-get install --no-install-recommends -y nodejs npm git ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade

# manually create a symlink /usr/bin/node
RUN ln -s `which nodejs` /usr/bin/node

# Copy entire project
ADD / /server

WORKDIR /
RUN npm install --production && npm cache clean --force;

EXPOSE 8000

# CMD [ "npm", "start" ]
