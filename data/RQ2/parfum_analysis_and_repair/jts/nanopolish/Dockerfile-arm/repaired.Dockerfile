FROM multiarch/ubuntu-debootstrap:arm64-bionic
RUN uname -a
RUN apt-get update -qq && \
  apt-get install -yq --no-install-suggests --no-install-recommends \
  bzip2 \
  ca-certificates \
  gcc \
  g++ \
  make \
  software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y universe && \
  apt-get update -qq && \
  apt-get install --no-install-recommends -yq libhdf5-dev && rm -rf /var/lib/apt/lists/*;
RUN find /usr/include -name "hdf5.h" || true
RUN find /usr/lib -name "libhdf5.a" || true
WORKDIR /nanopolish
COPY . .
CMD exec bash -c "make && make test"
