FROM ubuntu:16.04
MAINTAINER "keller.eric@gmail.com"

RUN apt-get update && apt-get install -y --no-install-recommends task-spooler nodejs nodejs-legacy npm && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /tsp
COPY . /tsp

ENV TS_SOCKET=/tsp/tsp-queue.socket
WORKDIR /tsp

RUN npm install && npm cache clean --force;
EXPOSE 3000
ENTRYPOINT ["/usr/bin/node", "index.js"]

