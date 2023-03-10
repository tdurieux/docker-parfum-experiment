FROM centos:7 as base

ENV BUILD_REPOS="epel-release centos-release-scl" \
    BUILD_DEPS="cmake3 boost-devel libsodium-devel ncurses-devel protobuf-devel \
        protobuf-compiler gflags-devel protobuf-lite-devel git devtoolset-8"

WORKDIR /

RUN yum install -y $BUILD_REPOS && \
    yum install -y $BUILD_DEPS && \
    git clone --recurse-submodules https://github.com/MisterTea/EternalTerminal.git && \
    cd EternalTerminal && \
    mkdir build && \
    cd build && \
    bash -c "scl enable devtoolset-8 'cmake3 ../'" && \
    bash -c "scl enable devtoolset-8 'make -j $(grep ^processor /proc/cpuinfo |wc -l) && make install'" && rm -rf /var/cache/yum

FROM centos:7

RUN yum install -y epel-release && \
    yum install -y protobuf-lite libsodium && rm -rf /var/cache/yum

COPY --from=base /usr/local/bin/etserver /usr/local/bin/etterminal /usr/local/bin/htm /usr/local/bin/htmd  /usr/local/bin/
COPY --from=base /EternalTerminal/etc/et.cfg /etc/et.cfg
COPY container-entrypoint /bin/container-entrypoint

ENTRYPOINT ["/bin/container-entrypoint", "client"]
