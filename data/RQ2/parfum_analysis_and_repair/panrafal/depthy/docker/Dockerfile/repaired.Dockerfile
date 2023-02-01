FROM ubuntu:trusty
MAINTAINER Sébastien M-B <essembeh@gmail.com>

RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

ADD sources.list /etc/apt/

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs npm ruby-compass && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN npm install -g grunt-cli bower && npm cache clean --force;

RUN git clone https://github.com/panrafal/depthy.git
WORKDIR /depthy
RUN npm install && npm cache clean --force;
RUN bower install --allow-root --config.interactive=false

EXPOSE 9000
ENTRYPOINT grunt serve

