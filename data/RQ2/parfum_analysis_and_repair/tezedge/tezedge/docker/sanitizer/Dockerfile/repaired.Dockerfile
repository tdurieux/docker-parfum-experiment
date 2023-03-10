FROM tezedge/tezos-opam-builder:debian10 as build-env

# Checkout and compile tezedge source code
USER root

ARG tezedge_git="https://github.com/tezedge/tezedge.git"
ARG rust_toolchain="1.58.1"
ENV RUSTUP_HOME=/opt/rustup
ENV CARGO_HOME=/opt/cargo
RUN mkdir $RUSTUP_HOME
RUN mkdir $CARGO_HOME
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain ${rust_toolchain} -y
ENV PATH=$CARGO_HOME/bin:$PATH
ENV RUST_BACKTRACE=1
ENV SODIUM_USE_PKG_CONFIG=1
ENV OCAML_BUILD_CHAIN=remote

#USER root
RUN apt-get update && apt-get install --no-install-recommends clang libclang-dev libssl-dev zlib1g -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends gosu -y && rm -rf /var/lib/apt/lists/*;
RUN echo "interceptor_via_lib:protocol-runner" > /asan.supp

RUN rustup component add rust-src
RUN chmod -R 777 /opt/cargo
COPY docker-entrypoint.sh /entry.sh
CMD ["/entry.sh"]
