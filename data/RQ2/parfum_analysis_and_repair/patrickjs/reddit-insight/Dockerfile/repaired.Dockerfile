FROM ubuntu
MAINTAINER Patrick Stapleton

RUN apt-get install --no-install-recommends -y python-software-properties python && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/node.js
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
#RUN apt-get install -y nodejs=0.6.12~dfsg1-1ubuntu1
RUN mkdir /var/www

RUN cd /var/www ; npm install && npm cache clean --force;

CMD ["/usr/bin/node", "/var/www/server.js"]
