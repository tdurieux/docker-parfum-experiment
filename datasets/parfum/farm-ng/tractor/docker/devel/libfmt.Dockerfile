ARG base_image=ubuntu:18.04
FROM $base_image
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    autoconf \
    build-essential \
    ca-certificates \
    libtool \
    pkg-config \
    python3-pip \
    wget \
    && \
    apt-get clean

RUN pip3 install --upgrade pip && pip3 install cmake
RUN wget https://github.com/fmtlib/fmt/archive/refs/tags/7.1.3.tar.gz && tar -xvzf 7.1.3.tar.gz


ARG PREFIX=/farm_ng/env
ARG PARALLEL=1
RUN set -ex && \
    mkdir -p build && cd build && \
    cmake \
    -DCMAKE_INSTALL_PREFIX=/fmt_install \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    ../fmt-7.1.3 && \
    cmake --build . --parallel $PARALLEL --target install --config Release


FROM scratch
ARG PREFIX=/farm_ng/env
COPY --from=0 /fmt_install $PREFIX
