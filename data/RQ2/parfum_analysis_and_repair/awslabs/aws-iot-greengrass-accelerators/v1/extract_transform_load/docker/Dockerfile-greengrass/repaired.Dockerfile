FROM amazon/aws-iot-greengrass:1.11.5-1-amazonlinux-x86-64

# Install system dependencies and supporting services for accelerator
RUN yum update -y && yum install -y procps wget git gcc && \
    rm -rf /var/cache/yum
WORKDIR /usr/local/src
RUN wget --quiet https://download.redis.io/redis-stable.tar.gz && \
    tar xzf redis-stable.tar.gz && \
    rm redis-stable.tar.gz && \
    cd redis-stable && \
    make distclean && \
    make && \
    mkdir /etc/redis && \
    cp src/redis-server src/redis-cli /usr/local/bin && \
    cd /opt && \
    git clone --branch v1.0.0 https://github.com/RedisTimeSeries/RedisTimeSeries.git && \
    cd RedisTimeSeries && \
    git submodule init && \
    git submodule update && \
    cd src && \
    make all && \
    mkdir -p /usr/local/lib/redis/modules && \
    cp redistimeseries.so /usr/local/lib/redis/modules
# RUN yum remove -y gcc && \
#     rm -rf /var/cache/yum

COPY redis.conf /etc/redis/

# Add python packages from requirements.txt
ADD requirements.txt /
WORKDIR /
RUN pip3.7 install -r requirements.txt

# Replace entrypoint with one that start supporting services
COPY greengrass-entrypoint.sh /