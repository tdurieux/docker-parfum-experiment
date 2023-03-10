FROM phusion/baseimage:0.9.17

RUN apt-get -u update

# If you have native dependencies, you'll need extra tools
# RUN apt-get install -y build-essential checkinstall autoconf libtool

# RethinkDB deps
RUN apt-get install --no-install-recommends -y python wget && rm -rf /var/lib/apt/lists/*;

RUN bash -c 'source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list'
RUN wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add -
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y rethinkdb && rm -rf /var/lib/apt/lists/*;

# NodeJS
RUN curl -f -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD config/logrotate /etc/logrotate.d/monitor

# Service
ADD service /etc/service/

# Data dir
RUN mkdir -p /data/rethinkdb
VOLUME /data/rethinkdb

RUN mkdir /app
RUN mkdir /var/log/monitor
WORKDIR /app
ADD . /app
RUN cd /app && npm install && npm cache clean --force;

EXPOSE 3000
EXPOSE 8080

#CMD ["node", "index.js"]
CMD ["/sbin/my_init"]
