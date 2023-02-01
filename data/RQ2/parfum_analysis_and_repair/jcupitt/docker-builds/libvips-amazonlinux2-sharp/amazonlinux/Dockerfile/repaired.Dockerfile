FROM amazonlinux:2

# general build stuff
RUN yum update -y \
  && yum groupinstall -y "Development Tools" \
  && yum install -y --setopt=tsflags=nodocs \
    wget \
    tar \
    gperf \
    gtk-doc \
    jq \
    nasm \
    prelink \
    python3 \
    gcc-c++ \
    advancecomp \
    cmake3 \
    gobject-introspection-devel \
    libtool \
    swig \
  && pip3 install --no-cache-dir meson ninja \
  && ln -s /usr/bin/cmake3 /usr/bin/cmake \
  && ln -s /usr/bin/ninja-build /usr/bin/ninja \
  && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    --no-modify-path \
    --profile minimal && rm -rf /var/cache/yum

RUN yum install -y \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rm -rf /var/cache/yum
RUN yum install -y libcxx brotli && rm -rf /var/cache/yum

ENV PREFIX=/usr/local/vips

ENV PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig \
  LD_LIBRARY_PATH=$PREFIX/lib \
  PATH=$PATH:$PREFIX/bin \
  WORKDIR=/usr/local/src

WORKDIR $WORKDIR
