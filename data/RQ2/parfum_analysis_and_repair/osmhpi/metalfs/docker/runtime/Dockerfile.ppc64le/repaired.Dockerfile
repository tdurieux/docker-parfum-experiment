FROM ubuntu:bionic AS build

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    build-essential \
    cmake \
    xxd \
    libcxl-dev \
    libfuse-dev \
    liblmdb-dev \
    libprotobuf-dev \
    protobuf-compiler \
 && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=

ADD . /src/metal_fs

RUN cd /src/metal_fs \
 && mkdir build \
 && cd build \
 && cmake \
   -DCMAKE_BUILD_TYPE=Release \
   -DOPTION_BUILD_TESTS=OFF \
   .. \
 && make -j8 \
 && make install

FROM ubuntu:bionic

COPY --from=build /usr/local/bin/metal-driver /usr/local/bin/

COPY --from=build /usr/local/include/ /usr/local/include/

COPY --from=build /usr/local/lib/libsnap.so /usr/local/lib/
COPY --from=build /usr/local/lib/libspdlog.so.1.5.0 /usr/local/lib/
RUN cd /usr/local/lib \
 && ln -s libspdlog.so.1.5.0 libspdlog.so.1 \
 && ln -s libspdlog.so.1 libspdlog.so

COPY --from=build /usr/local/lib/libmetal-*.so.1.0.0 /usr/local/lib/
RUN cd /usr/local/lib \
 && ln -s libmetal-driver-messages.so.1.0.0 libmetal-driver-messages.so.1 \
 && ln -s libmetal-driver-messages.so.1 libmetal-driver-messages.so
RUN cd /usr/local/lib \
 && ln -s libmetal-filesystem-pipeline.so.1.0.0 libmetal-filesystem-pipeline.so.1 \
 && ln -s libmetal-filesystem-pipeline.so.1 libmetal-filesystem-pipeline.so
RUN cd /usr/local/lib \
 && ln -s libmetal-filesystem.so.1.0.0 libmetal-filesystem.so.1 \
 && ln -s libmetal-filesystem.so.1 libmetal-filesystem.so
RUN cd /usr/local/lib \
 && ln -s libmetal-pipeline.so.1.0.0 libmetal-pipeline.so.1 \
 && ln -s libmetal-pipeline.so.1 libmetal-pipeline.so

COPY --from=build /usr/local/lib/cmake /usr/local/lib/

COPY --from=build /usr/local/share/metal_fs /usr/local/share/metal_fs
COPY --from=build /usr/local/share/snap /usr/local/share/snap

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    fuse \
    liblmdb0 \
    libprotobuf10 \
    libcxl1 \
 && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=

CMD metal-driver