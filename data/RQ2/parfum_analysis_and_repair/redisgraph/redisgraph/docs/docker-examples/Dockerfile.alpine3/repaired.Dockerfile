# BUILD redisfab/redisgraph:6.2.4-x64-alpine3

ARG PACK=0
ARG TEST=0

#----------------------------------------------------------------------------------------------
FROM redisfab/redis:6.2.4-x64-alpine3 AS redis
# Build based on alpine:latest (i.e., 'builder'), redis files are copies from 'redis'
FROM alpine:latest AS builder

RUN echo "Building for alpine3 (alpine:latest) for x64 [with Redis 6.2.4]"

WORKDIR /build

COPY --from=redis /usr/local/ /usr/local/

ADD ./ /build

# Set up a build environment

RUN ./deps/readies/bin/getbash

RUN ./deps/readies/bin/getpy3
RUN ./deps/readies/bin/getupdates
RUN ./sbin/system-setup.py

RUN if [ ! -z $(command -v apt-get) ]; then \
        locale-gen --purge en_US.UTF-8 ;\
        dpkg-reconfigure -f noninteractive locales ;\
    fi

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN bash -l -c make -j`nproc`

ARG PACK
ARG TEST

RUN set -ex ;\
    if [ "$TEST" = "1" ]; then bash -l -c "TEST= make test"; fi
RUN set -ex ;\
    mkdir -p bin/artifacts ;\
    if [ "$PACK" = "1" ]; then bash -l -c "make package"; fi

#----------------------------------------------------------------------------------------------

FROM redis:6-alpine


ARG PACK

ENV LIBDIR /usr/lib/redis/modules

WORKDIR /data

RUN mkdir -p $LIBDIR

COPY --from=builder /build/bin/artifacts/ /var/opt/redislabs/artifacts
COPY --from=builder /build/src/redisgraph.so $LIBDIR

RUN if [ -f /usr/bin/apt-get ]; then \
 apt-get -qq update; apt-get -q --no-install-recommends install -y libgomp1; rm -rf /var/lib/apt/lists/*; fi
RUN if [ -f /usr/bin/yum ]; then \
 yum install -y libgomp; rm -rf /var/cache/yumfi
RUN if [ -f /sbin/apk ]; then \
 apk add --no-cache libgomp; fi

EXPOSE 6379
CMD ["redis-server", "--loadmodule", "/usr/lib/redis/modules/redisgraph.so"]