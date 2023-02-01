FROM busybox

RUN mkdir -p /data/logs/zankv/ && yum install -y rsync snappy jemalloc && rm -rf /var/cache/yum
ADD dist/docker/bin/ /opt/zankv/bin/
ADD scripts/ /opt/zankv/scripts/

EXPOSE 18001 12380 12381 12379

VOLUME /data
