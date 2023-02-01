FROM ubuntu:20.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy \
        build-essential pkg-config libfuse-dev cmake && rm -rf /var/lib/apt/lists/*;
COPY . /usr/src/fatx
WORKDIR /usr/src/fatx
RUN mkdir build \
 && cd build \
 && cmake .. \
 && make DESTDIR=/fatx install

FROM ubuntu:20.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy fuse && rm -rf /var/lib/apt/lists/*;
COPY --from=0 /fatx /fatx
RUN cp -ruT /fatx / && rm -rf /fatx
