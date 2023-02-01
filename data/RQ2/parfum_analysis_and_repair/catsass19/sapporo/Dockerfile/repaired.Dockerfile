FROM node:4.6
MAINTAINER Sapporo
ADD ./Sapporo.tar.gz /sapporo/
RUN apt-get update && apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN cd /sapporo/bundle/programs/server && npm install && npm cache clean --force;
