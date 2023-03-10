# FROM rust:1.39
# We need nightly currently for compiling with singlepass
FROM rustlang/rust:nightly

# Install build dependencies
RUN apt-get update
RUN apt install --no-install-recommends -y clang gcc g++ zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y build-essential cmake && rm -rf /var/lib/apt/lists/*;

# add some llvm configs for later - how to cross-compile this in wasmer-llvm-backend???
RUN echo deb http://deb.debian.org/debian buster-backports main >> /etc/apt/sources.list
RUN apt-get update
RUN apt install --no-install-recommends -y libllvm8 llvm-8 llvm-8-dev llvm-8-runtime && rm -rf /var/lib/apt/lists/*;
ENV LLVM_SYS_80_PREFIX=/usr/lib/llvm-8

## ADD MACOS SUPPORT

WORKDIR /opt

# Pin to proper nightly and add macOS Rust target
RUN rustup default nightly-2020-06-08
RUN rustup target add x86_64-apple-darwin

# Build osxcross
RUN git clone https://github.com/tpoechtrager/osxcross
RUN cd osxcross && \
	wget -nc https://s3.dockerproject.org/darwin/v2/MacOSX10.10.sdk.tar.xz && \
    mv MacOSX10.10.sdk.tar.xz tarballs/ && \
    UNATTENDED=yes OSX_VERSION_MIN=10.7 ./build.sh
RUN chmod +rx /opt/osxcross
RUN chmod +rx /opt/osxcross/target
RUN chmod -R +rx /opt/osxcross/target/bin

## TODO: add support for windows cross-compile

# PRE-FETCH MANY DEPS
WORKDIR /scratch
COPY Cargo.toml /scratch/
COPY Cargo.lock /scratch/
COPY src /scratch/src
RUN cargo fetch
# allow non-root user to download more deps later
RUN chmod -R 777 /usr/local/cargo

## COPY BUILD SCRIPTS

WORKDIR /code
RUN rm -rf /scratch

COPY build/*.sh /opt/
RUN chmod +x /opt/*.sh

RUN mkdir /.cargo
RUN chmod +rx /.cargo
COPY build/cargo-config /.cargo/config

CMD ["/opt/build_osx.sh"]
