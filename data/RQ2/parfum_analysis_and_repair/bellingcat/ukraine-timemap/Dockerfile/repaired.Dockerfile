FROM mhart/alpine-node:10.11

LABEL authors="Lachlan Kermode <lk@forensic-architecture.org>"

# Install app dependencies
COPY package.json /www/package.json
RUN cd /www; yarn && yarn cache clean;

# Copy app source
COPY . /www
WORKDIR /www
RUN yarn build && yarn cache clean;

# files available to copy at /www/build
