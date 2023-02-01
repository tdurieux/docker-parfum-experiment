# Language pack with Go runtime
FROM ubuntu:trusty

MAINTAINER Devdatta Kulkarni <devdatta.kulkarni@rackspace.com>

RUN apt-get -yqq update && apt-get -yqq --no-install-recommends install curl build-essential libxml2-dev libxslt-dev git autoconf wget golang && rm -rf /var/lib/apt/lists/*;

ADD hello.go /tmp/hello.go

ADD testgo.sh /tmp/testgo.sh

RUN cd /tmp && bash testgo.sh

