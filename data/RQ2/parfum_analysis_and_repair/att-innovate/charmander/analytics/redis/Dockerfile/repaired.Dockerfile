FROM analyticsbase
MAINTAINER Charmander

RUN apt-get install --no-install-recommends -y build-essential make gcc && rm -rf /var/lib/apt/lists/*;

ENV REDISVERSION 2.8.11

RUN wget \
    --no-cookies \
    --progress=bar:force \
    https://github.com/antirez/redis/archive/$REDISVERSION.tar.gz \
    && tar xzf $REDISVERSION.tar.gz \
    && cd redis-$REDISVERSION \
    && make \
    && cd .. \
    && ln -sfn redis-$REDISVERSION redis && rm $REDISVERSION.tar.gz

#VOLUME [ "/data" ]
RUN mkdir /data

ADD files/redis.conf redis.conf

EXPOSE 6379

ENV NODEVERSION v0.10.30
ENV CMDVERSION 0.2.1
RUN wget \
    --no-cookies \
    --progress=bar:force \
    https://nodejs.org/dist/$NODEVERSION/node-$NODEVERSION-linux-x64.tar.gz \
    && tar -xvf node-$NODEVERSION-linux-x64.tar.gz \
    && mv node-$NODEVERSION-linux-x64 /opt/node \
    && cd /usr/local/bin && ln -s /opt/node/bin/* . \
    && npm install -g redis-commander@$CMDVERSION && npm cache clean --force; && rm node-$NODEVERSION-linux-x64.tar.gz

EXPOSE 8081

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT redis/src/redis-server redis.conf & redis-commander
