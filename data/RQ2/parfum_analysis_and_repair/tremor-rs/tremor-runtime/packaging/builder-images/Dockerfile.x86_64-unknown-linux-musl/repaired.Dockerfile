ARG RUST_VERSION

# update the version here as needed
# via https://hub.docker.com/_/rust
FROM rustembedded/cross:x86_64-unknown-linux-musl-0.2.1

# install musl
# this setup borrowed from https://github.com/rust-embedded/cross/blob/v0.2.0/docker/musl.sh#L44
# not using cross's default image there directly since that has older gcc (6.4)
# which does not work for our dependencies like snmalloc
#
# once https://github.com/rust-embedded/cross/issues/432 is resolved, we can
# probably get rid of this and base our image from the relevant cross default
# image here (rustembedded/cross:x86_64-unknown-linux-musl).
RUN temp_dir=$(mktemp -d) \
  && cd $temp_dir \
  && curl -f -L https://github.com/richfelker/musl-cross-make/archive/v0.9.9.tar.gz | tar --strip-components=1 -xz \
  && make install -j$(nproc) \
  GCC_VER=9.2.0 \
  MUSL_VER=1.2.0 \
  DL_CMD="curl -C - -L -o" \
  OUTPUT=/usr/local/ \
  TARGET=x86_64-linux-musl \
  && rm -rf $temp_dir


RUN apt-get update; \
  apt-get install --no-install-recommends -y \
  cmake `# for building C deps` \
  libclang-dev `# for onig_sys (via the regex crate)` \
  libssl-dev `# for openssl (via surf)` \
  libsasl2-dev `# for librdkafka` \
  libzstd-dev `# for librdkafka`; \
  apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

#COPY shared/entrypoint.sh /
#ENTRYPOINT [ "/entrypoint.sh" ]


ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER=x86_64-linux-musl-gcc \
  CC_x86_64_unknown_linux_musl=x86_64-linux-musl-gcc \
  CXX_x86_64_unknown_linux_musl=x86_64-linux-musl-g++


# COPY shared/entrypoint.sh /
# ENTRYPOINT [ "/entrypoint.sh" ]
