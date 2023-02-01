# DOCKER-VERSION 0.6.1

FROM  ubuntu:12.04

RUN apt-get install --no-install-recommends -y python-software-properties python && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/node.js
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y nodejs supervisor redis-server && rm -rf /var/lib/apt/lists/*;

ADD ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor

ADD . /src/vmux
RUN cd /src/vmux; npm install && npm cache clean --force;

EXPOSE 5000
EXPOSE 3478

CMD ["supervisord", "-n"]
