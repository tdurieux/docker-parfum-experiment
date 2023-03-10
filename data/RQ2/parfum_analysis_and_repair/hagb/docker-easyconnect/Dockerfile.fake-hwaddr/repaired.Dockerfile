FROM debian:buster-slim AS fake-hwaddr

ARG BUILD_ENV=local

RUN if [ "${BUILD_ENV}" = "local" ]; then sed -i s/deb.debian.org/mirrors.aliyun.com/ /etc/apt/sources.list; fi &&\
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests gcc libc6-dev make && rm -rf /var/lib/apt/lists/*;

COPY fake-hwaddr ./fake-hwaddr/

RUN cd fake-hwaddr && make
