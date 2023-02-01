FROM ricejasonf/emscripten:1.37.39 AS cctools

  # cctools (linker for darwin targets)
  RUN git clone --depth 1 https://github.com/tpoechtrager/cctools-port.git \
    && cd cctools-port/cctools \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /opt/install \
    && make \
    && make install

FROM ricejasonf/emscripten_fastcomp:1.37.39

  RUN apt-get update && apt-get -yq --no-install-recommends install \
    cmake python bash-completion vim \
    && echo '. /usr/share/bash-completion/bash_completion && set -o vi' >> /root/.bashrc \
    && echo 'set hlsearch' >> /root/.vimrc \
    && mkdir /opt/install \
    && mkdir /opt/build \
    && ln -s /usr/local /opt/sysroot && rm -rf /var/lib/apt/lists/*;

  COPY cppdock /usr/local/bin
  COPY recipes/ /root/.cppdock_recipes
  COPY ./toolchain/tvossimulator.cmake /opt/toolchain.cmake
  COPY ./toolchain/tvossimulator/Availability.h /opt/sysroot/include/
  COPY ./toolchain/tvossimulator/AvailabilityInternal.h /opt/sysroot/include/
  COPY --from=cctools /opt/install /opt/sysroot
