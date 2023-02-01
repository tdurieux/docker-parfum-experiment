FROM proot-me/proot:debian

RUN apt update && \
    apt install --no-install-recommends -y \
      curl \
      docutils-common \
      git \
      libarchive-dev \
      libtalloc-dev \
      make \
      sloccount \
      strace \
      swig \
      uthash-dev \
      xsltproc && rm -rf /var/lib/apt/lists/*;

