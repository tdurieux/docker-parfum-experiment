# rust_icu_buildenv.
FROM rust:1.56 AS buildenv

RUN mkdir -p /src

WORKDIR /src
RUN ls -l && pwd && echo $PATH

RUN rustc --version

RUN apt-get update && apt-get install --no-install-recommends -y \
apt-utils \
clang \
coreutils \
curl \
exuberant-ctags \
gawk \
git \
libclang-dev \
llvm-dev \
strace \
"" && rm -rf /var/lib/apt/lists/*;

RUN \
cargo version && \
rustup component add rustfmt

RUN \
cargo install --force bindgen

RUN chmod --recursive a+rwx $HOME
RUN echo $HOME && cd && ls -ld $HOME


