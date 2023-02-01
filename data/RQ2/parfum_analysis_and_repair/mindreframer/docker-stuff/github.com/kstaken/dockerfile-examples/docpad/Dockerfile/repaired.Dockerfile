FROM ubuntu
MAINTAINER Kimbro Staken

RUN apt-get install --no-install-recommends -y python-software-properties python && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/node.js
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y nodejs git && rm -rf /var/lib/apt/lists/*;
RUN npm install -g docpad@6.44 && npm cache clean --force;

CMD ["/bin/bash"]