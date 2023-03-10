ARG VERSION=latest
ARG ARCH=armv8

ARG REDIS_VERSION=latest

FROM redis:${REDIS_VERSION} as redis

ADD . /build
WORKDIR /build
RUN ./deps/readies/bin/getpy3
RUN ./system-setup.py
RUN make fetch

#ENV X_NPROC "cat /proc/cpuinfo|grep processor|wc -l"
#RUN echo nproc=$(nproc); echo NPROC=$(eval "$X_NPROC")
RUN make -j `nproc` build

# --------------------------------------------------------
FROM redis
RUN mkdir -p /usr/lib/redis/modules
COPY --from=redis /build/bin/redistimeseries.so /usr/lib/redis/modules

CMD ["redis-server", "--loadmodule", "/usr/lib/redis/modules/redistimeseries.so"]