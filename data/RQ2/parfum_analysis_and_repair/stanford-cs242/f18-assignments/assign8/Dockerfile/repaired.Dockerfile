FROM ubuntu:18.04
RUN apt update && apt-get install --no-install-recommends -y curl git python lua5.3 liblua5.3-dev luarocks && rm -rf /var/lib/apt/lists/*;
RUN echo "termfx busted luacheck mobdebug debug.lua argparse" | xargs -n 1 luarocks install

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y

ENV PATH=/root/.cargo/bin:$PATH

CMD ["/bin/bash"]