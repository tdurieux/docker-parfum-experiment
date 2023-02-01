FROM debian:jessie
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
ADD add_4.tar /
MAINTAINER John Doe <john@doe.com>
