FROM noiro/opflex-build-base
ARG BUILDOPTS="--enable-grpc"
WORKDIR /opflex
COPY libopflex /opflex/libopflex
ARG make_args=-j4
RUN cd /opflex/libopflex \
  && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-assert \
  && make $make_args && make install && make clean
COPY genie /opflex/genie
RUN cd /opflex/genie/target/libmodelgbp \
  && sh autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-static \
  && make $make_args && make install && make clean
COPY agent-ovs /opflex/agent-ovs
RUN cd /opflex/agent-ovs \
  && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" $BUILDOPTS \
  && make $make_args && make install && make clean
RUN for p in `find /usr/local/lib/ /usr/local/bin/ -type f \(\
    -name 'opflex_agent' -o \
    -name 'gbp_inspect' -o \
    -name 'mcast_daemon' -o \
    -name 'opflex_server' -o \
    -name 'libopflex*so*' -o \
    -name 'libmodelgbp*so*' -o \
    -name 'libopenvswitch*so*' -o \
    -name 'libsflow*so*' -o \
    -name 'libprometheus-cpp-*so*' -o \
    -name 'libgrpc*so*' -o \
    -name 'libproto*so*' -o \
    -name 'libre2*so*' -o \
    -name 'libupb*so*' -o \
    -name 'libabsl*so*' -o \
    -name 'libssl*so*' -o \
    -name 'libcrypto*so*' -o \
    -name 'libaddress_sorting*so*' -o \
    -name 'libgpr*so*' -o \
    -name 'libofproto*so*' \
    \)`; do \
       objcopy --only-keep-debug "$p" "$p.debug"; \
       objcopy --strip-debug "$p"; \
       objcopy --add-gnu-debuglink="$p.debug" "$p"; \
     done
