# Build image
FROM ubuntu:18.04 AS build

ARG D_RDMA_CORE_TAG=v31.0
ARG D_PERFTEST_TAG=4.4-0.29

WORKDIR /root
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install apt-utils git autotools-dev autoconf libtool build-essential \
cmake gcc libudev-dev libnl-3-dev libnl-route-3-dev ninja-build pkg-config python3-dev cython3 && rm -rf /var/lib/apt/lists/*;

# Compile and install rdma-core
RUN git clone --branch ${D_RDMA_CORE_TAG} https://github.com/linux-rdma/rdma-core.git
RUN /bin/bash -c 'cd /root/rdma-core && ./build.sh && cd build && cp -R lib/* /usr/lib && cp -R etc/* /etc/ && cp -R include/* /usr/include/'
# Compile perftest
RUN git clone --branch ${D_PERFTEST_TAG} https://github.com/linux-rdma/perftest.git
RUN /bin/bash -c 'cd /root/perftest && ./autogen.sh && ./configure && make'

# Application image
FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -yq install pciutils net-tools iproute2 libnl-3-dev libnl-route-3-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /root

# Install rdma-core and delete sources
COPY --from=build /root/rdma-core ./rdma-core
RUN /bin/bash -c 'cd ./rdma-core/build && cp -R lib/* /usr/lib && cp -R etc/* /etc/ && cp -R include/* /usr/include/'
RUN rm -rf ./rdma-core

# Install perftest and delete sources
COPY --from=build /root/perftest ./perftest
RUN /bin/bash -c 'cd ./perftest && cp ib_* /usr/bin'
RUN rm -rf ./perftest

ADD ./entrypoint.sh ./
ENTRYPOINT ["/root/entrypoint.sh"]
