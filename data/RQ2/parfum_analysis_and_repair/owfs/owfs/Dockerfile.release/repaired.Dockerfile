# Please see RELEASE.md for usage information

FROM ubuntu:18.04

RUN apt update && apt -y --no-install-recommends install autoconf make libtool pkg-config && apt clean && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

ENV GITREF=master
VOLUME ['/extsrc']

WORKDIR /build
CMD git clone /extsrc/.git owfs && \
    cd owfs && \
    git checkout ${GITREF} && \
    git show -q && \
    ./bootstrap && \
    ./configure && \
    make clean && \
    make dist && \
    make distclean && \
    cp -v owfs-*tar.gz /out
