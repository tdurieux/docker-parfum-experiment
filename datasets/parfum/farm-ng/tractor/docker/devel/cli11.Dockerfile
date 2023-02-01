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
RUN wget https://github.com/CLIUtils/CLI11/archive/4af78beef777e313814b4daff70e2da9171a385a.tar.gz && tar -xvzf 4af78beef777e313814b4daff70e2da9171a385a.tar.gz


ARG PREFIX=/farm_ng/env
ARG PARALLEL=1
RUN set -ex && \
    mkdir -p build && cd build && \
    cmake \
    -DCMAKE_INSTALL_PREFIX=/cli11_install \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCLI11_BUILD_TESTS=OFF \
    -DCLI11_BUILD_EXAMPLES=OFF \
    ../CLI11-4af78beef777e313814b4daff70e2da9171a385a && \
    cmake --build . --parallel $PARALLEL --target install --config Release


FROM scratch
ARG PREFIX=/farm_ng/env
COPY --from=0 /cli11_install $PREFIX
