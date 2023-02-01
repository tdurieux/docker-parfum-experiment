#FROM dockerfile/nodejs:latest
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y curl wget nodejs && rm -rf /var/lib/apt/lists/*;

ADD ./demo /demo

RUN ln -s /usr/bin/nodejs /usr/bin/node

VOLUME /demo

EXPOSE 3000
CMD    ["/demo/bin/www"]