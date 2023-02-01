FROM quintenk/supervisor

MAINTAINER Quinten Krijger "https://github.com/Krijger"

RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.9.tgz -O /tmp/mongo.tar.gz
RUN mkdir -p /data/db
RUN ln -s /opt/mongodb/bin/mongo /usr/local/bin/mongo
RUN ln -s /opt/mongodb/bin/mongod /usr/local/bin/mongod
RUN ( cd /tmp && tar zxf mongo.tar.gz && mv mongodb-* /opt/mongodb) && rm mongo.tar.gz
RUN rm -rf /tmp/*

ADD mongo.sv.conf /etc/supervisor/conf.d/

