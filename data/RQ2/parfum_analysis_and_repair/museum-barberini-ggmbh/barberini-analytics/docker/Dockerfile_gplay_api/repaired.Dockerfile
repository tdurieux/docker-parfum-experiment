# This dockerfile is used to create containers that run a web
# server that serves the google-play-api (see
# https://github.com/facundoolano/google-play-api)

FROM ubuntu:18.04
WORKDIR /

ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN apt-get update
RUN apt-get upgrade -y --no-install-recommends apt-utils

ARG INSTALL='apt-get install -y'

# Install utilities
RUN $INSTALL curl git

# Clone google-play-api repo
RUN git clone https://github.com/facundoolano/google-play-api.git 2>&1
WORKDIR /google-play-api

# Set google play api to a commit that is known to work. If the repo
# gets updated it may be wise to set the commit hash below to the new HEAD.
RUN git reset 6d0e649a1f50ef26721f911032292f87e4f1383c --hard

# Install node.js and npm
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN $INSTALL nodejs

# Install google-play-api with npm
RUN npm install && npm cache clean --force;

# The server runs on port 3000
EXPOSE 3000
# The server should start when the container is started
CMD npm start
