FROM ubuntu:18.04 as builder

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential perl make automake autoconf m4 git libtool-bin && rm -rf /var/lib/apt/lists/*;

RUN git clone -b sockperf_v2 --single-branch  https://github.com/Mellanox/sockperf.git

WORKDIR /sockperf

RUN git checkout b3df070d564973c9d6a4a0e143de7703043c5713

COPY mystikos_changes.patch /sockperf
RUN git apply mystikos_changes.patch

RUN ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-test \
    && make \
    && make install

FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

COPY --from=builder /sockperf/sockperf /app
