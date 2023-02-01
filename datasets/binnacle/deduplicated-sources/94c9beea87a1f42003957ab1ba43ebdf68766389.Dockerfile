# © Copyright IBM Corporation 2017, 2019.
# LICENSE: Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0)

########## Dockerfile for Redis version 5.0.5 #########
#
# This Dockerfile builds a basic installation of Redis.
#
# Redis is an open source (BSD licensed), in-memory data structure store, used as database, cache and message broker.
# It supports data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs
# and geospatial indexes with radius queries.
# Redis has built-in replication, Lua scripting, LRU eviction, transactions and different levels of on-disk persistence,
# and provides high availability via Redis Sentinel and automatic partitioning with Redis Cluster.
#
# To build this image, from the directory containing this Dockerfile
# (assuming that the file is named Dockerfile):
# docker build -t <image_name> .
#
# To simply run the resultant image, and provide a bash shell:
# docker run --name <container_name> -it <image_name> /bin/bash
#
# To start redis server run below command.
# docker run --name <container_name>  -v /home/redis.conf:/home/redis.conf --rm=true -d <image_name> redis-server /home/redis.conf
#
#####################################################################

# Base image
FROM s390x/ubuntu:16.04

ARG REDIS_VER=5.0.5

# The author
MAINTAINER LoZ Open Source Ecosystem (https://www.ibm.com/developerworks/community/groups/community/lozopensource)

ENV SOURCE_DIR=/root
WORKDIR $SOURCE_DIR

# Install dependencies
RUN apt-get update &&  apt-get install -y \
    gcc      \
    g++       \
    make      \
    tcl       \
    git       \

# Clone redis repo 
&& git clone https://github.com/antirez/redis.git \
&& cd redis \
&& git checkout $REDIS_VER \

# Build redis
&& make distclean \
&& make \

# Install redis
&& make install \

# Tidy and clean up
&& rm -rf $SOURCE_DIR \
&& apt-get remove -y \
    gcc      \
    g++       \
    make      \
    tcl       \
    git       \
&& apt-get autoremove -y \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose redis-server port 6379
EXPOSE 6379

# Start redis-server on container run
CMD ["redis-server"]

# End of Dockerfile
