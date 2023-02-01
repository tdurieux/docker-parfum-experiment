FROM ubuntu
MAINTAINER Philip Peterson

# RUN apt-get install -y software-properties-common python
# RUN add-apt-repository ppa:chris-lea/node.js
# RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/source

ADD . /var/source
