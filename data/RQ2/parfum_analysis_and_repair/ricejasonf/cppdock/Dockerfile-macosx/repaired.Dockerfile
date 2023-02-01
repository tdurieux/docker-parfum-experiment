FROM ricejasonf/emscripten:1.37.39 AS cctools

  # cctools (linker for darwin targets)
  RUN git clone https://github.com/tpoechtrager/cctools-port.git \
    && cd cctools-port/cctools \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /opt/install \
    && make \
    && make install

FROM ricejasonf/emscripten:1.37.19

  RUN apt-get update && apt-get -yq --no-install-recommends install \
    cmake python bash-completion vim patch clang libxml2-devel \
    && echo '. /usr/share/bash-completion/bash_completion && set -o vi' >> /root/.bashrc \
    && echo 'set hlsearch' >> /root/.vimrc && rm -rf /var/lib/apt/lists/*;

  COPY cppdock /usr/local/bin
  COPY recipes/ /root/.cppdock_recipes
  COPY ./toolchain/macosx.cmake /opt/toolchain.cmake
  COPY --from=cctools /opt/install /usr/local
