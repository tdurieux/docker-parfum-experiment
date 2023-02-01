FROM distcc/base

LABEL maintainer=""

RUN apt-get update && \
    apt-get install -y --no-install-recommends clang-3.8 build-essential && \
    apt-get remove gcc g++ && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.8 50 && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang-3.8 50 && rm -rf /var/lib/apt/lists/*;
