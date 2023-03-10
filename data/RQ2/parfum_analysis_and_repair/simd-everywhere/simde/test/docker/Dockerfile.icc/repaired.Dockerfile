FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  cmake \
  gcc \
  gnupg \
  g++ \
  libstdc++-9-dev \
  make \
  wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB -O- | apt-key add -
RUN echo deb https://apt.repos.intel.com/oneapi all main > /etc/apt/sources.list.d/inteloneapi.list
RUN apt-get update && apt-get install --no-install-recommends -y intel-oneapi-icc && rm -rf /var/lib/apt/lists/*;
COPY . /simde
WORKDIR /simde
RUN mkdir -p test/build_s390x
WORKDIR /simde/test/build_s390x
RUN bash -c 'source /opt/intel/inteloneapi/compiler/latest/env/vars.sh && \
  CC=icc CXX=icpc cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DCMAKE_C_FLAGS="-wd13200 -wd13203" -DCMAKE_CXX_FLAGS="-wd13200 -wd13203" ../ && \
  make -j$(nproc)'
RUN ./run-tests
