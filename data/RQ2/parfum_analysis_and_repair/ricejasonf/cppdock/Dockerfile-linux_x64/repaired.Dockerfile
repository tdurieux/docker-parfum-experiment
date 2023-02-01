FROM ubuntu:eoan

  RUN apt-get update && apt-get -yq --no-install-recommends install \
    cmake python bash-completion vim \
    && echo '. /usr/share/bash-completion/bash_completion && set -o vi' >> /root/.bashrc \
    && echo 'set hlsearch' >> /root/.vimrc \
    && ln -s /usr/local /opt/sysroot && rm -rf /var/lib/apt/lists/*;

  COPY toolchain/linux_x64.cmake /opt/toolchain.cmake
  COPY --from=ricejasonf/heavy_compiler /opt/install/ /usr/local
  RUN ldconfig
