# https://github.com/debauchee/barrier
ARG BARRIER_VERSION=2.1.2
RUN cd /tmp && \
    curl -fsSL -O https://github.com/debauchee/barrier/archive/v${BARRIER_VERSION}.tar.gz && \
    tar -xzf v${BARRIER_VERSION}.tar.gz && \
    cd barrier-${BARRIER_VERSION} && \
    ./clean_build.sh && \
    cd build && \
    make install && rm v${BARRIER_VERSION}.tar.gz# installs to /usr/local/

