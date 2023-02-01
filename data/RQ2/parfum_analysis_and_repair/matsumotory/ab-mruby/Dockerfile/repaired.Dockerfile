#
# Dockerfile for ab-mruby on ubuntu 14.04 64bit
#

#
# Using Docker Image matsumotory/ab-mruby
#
# Pulling
#   docker pull matsumotory/ab-mruby
#
# Running
#  docker run -d matsumotory/ab-mruby http://example.com/
#

#
# Manual Build
#
# Building
#   docker build -t your_name:ab-mruby .
#
# Runing
#   docker run -d your_name:ab-mruby http://example.com/
#

FROM ubuntu:14.04
MAINTAINER matsumotory

RUN apt-get -y update
RUN apt-get -y --no-install-recommends install rake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bison && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libapr1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libaprutil1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install make && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/src/ && git clone git://github.com/matsumoto-r/ab-mruby.git
RUN cd /usr/local/src/ab-mruby && make && cp ab-mruby /usr/bin/.

ADD docker/ab-mruby.conf.rb /etc/ab-mruby/ab-mruby.conf.rb
ADD docker/ab-mruby.test.rb /etc/ab-mruby/ab-mruby.test.rb

ENTRYPOINT ["/usr/bin/ab-mruby", "-m", "/etc/ab-mruby/ab-mruby.conf.rb", "-M", "/etc/ab-mruby/ab-mruby.test.rb"]
