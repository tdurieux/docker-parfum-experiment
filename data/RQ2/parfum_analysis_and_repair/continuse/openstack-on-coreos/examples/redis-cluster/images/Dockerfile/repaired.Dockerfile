FROM       ubuntu:14.04
MAINTAINER Jaewoo Lee <continuse@icloud.com>

RUN apt-get update && apt-get install --no-install-recommends -y gcc make ruby expect telnet curl wget python-pip && rm -rf /var/lib/apt/lists/*;

RUN wget https://download.redis.io/releases/redis-3.0.3.tar.gz
RUN tar xvfz redis-3.0.3.tar.gz && cd redis-3.0.3 && make && make install && rm redis-3.0.3.tar.gz

# ETCD for python
RUN cd /tmp && wget https://github.com/jplana/python-etcd/archive/0.4.1.tar.gz && \
    tar xvfz 0.4.1.tar.gz && cd python-etcd-0.4.1 && pip install --no-cache-dir . && rm 0.4.1.tar.gz

# Python for Redis Cluster
RUN wget https://github.com/ContinUSE/redis-py-cluster/archive/1.0.0.tar.gz \
	&& tar xvfz 1.0.0.tar.gz \
	&& cd redis-py-cluster-1.0.0 \
	&& pip install --no-cache-dir . && rm 1.0.0.tar.gz

RUN gem install redis

COPY redis.conf /redis.conf
COPY auto_config_redis_cluster.py /auto_config_redis_cluster.py
COPY entrypoint.sh /entrypoint.sh

EXPOSE 6379

#CMD    ["/usr/local/bin/redis-server", "/redis.conf"]
CMD    ["/entrypoint.sh"]
