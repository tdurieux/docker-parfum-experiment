# a minimal Dockerized `redis-server`

FROM scratch

ADD  rootfs.tar.gz  /
COPY redis.conf     /etc/redis/redis.conf

# Redis port.