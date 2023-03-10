FROM debian:stretch
MAINTAINER Pyry Kontio <pyry.kontio@drasa.eu>
USER root

# NOTES TO MYSELF AND OTHERS TOO. THEY MIGHT BE HELPFUL,
# since this took me too long to figure out.

# This image is for building apps in Rust nightly for musl target.
# It contains the needed libraries to be able to build Diesel and Rocket.
# Setting up the build environment isn't actually easy at all – because
# Diesel and Rocket use code-generating compiler plugins, they plugins
# must be able to run in the host environment, whereas we want the final build
# to be a statically linked musl build. So we need to set up the environment
# doubly and ensure that the libraries are compatible and the correct libraries
# are selected.

# This dockerfile is easy to build with associated build.sh script.
# While building, it assembles the build environment for compiling static musl binaries.
# The pain of static compiling is the native dependencies,
# but with correct configuration, it should be all right.
# You need to download the C libraries, build the sources with appropriate
# settings and check from the appropriate Rust crates (usually named something-sys)
# how they are going to present the linking flags to Cargo.
# Read the build.rs files of those crates. Usually you need to set some
# environment variables that affect how the build.rs build scripts work.

# Note: if build.rs doesn't provide options for static linking
# and/or cross-compiling, forking the crate, cargo-patching it
# and adding that functionality is a thing! It helps everyone.
# The build.rs scripts provide the linking flags to cargo by printing some
# instructions like `println!("cargo:rustc-link-lib=static={}", lib);`,
# where lib is the libname as passed to linker [pq, ssl, crypto etc.].)
# Remember to contribute to upstream too!

# Note about compiler plugins.
# The compiler plugins run in the HOST environment alongside the compiler,
# whereas the compiled binary is of the TARGET environment.
# In this image, HOST is x86_64-unknown-linux-musl
# and TARGET is x86_64-unknown-linux-gnu.
# Additionally compiler plugins are dynamically linked.
# This all means that you need to have installed both
# dynamically linked HOST libraries for compiler plugins
# and statically linked TARGET libraries for linking.

# Note about the OpenSSL version:
# The version is configurable. I tried using 1.1.0 briefly,
# but it introduced some problems with its stricter cert checking,
# so now the build.sh defaults to 1.0.2. This can be easily changed, however,
# and the build environment fully supports building 1.1.0.

# Note about the distro version:
# Debian Stretch (9) introduced GCC that defaults to position-independent code.
# The support for linking PIE code statically was added to Rust recently (2017-08-25).
# Before that it used to link the libraries statically, but still produce
# a dynamic looking executable (a binary with a reference to the dynamic loader),
# which partially defeats the purpose.
# No support is guaranteed for older Rust nightlies than that.

# USAGE:
# When run, this image compiles can be used to compile static musl builds,
# presenting the --target=x86_64-unknown-linux-musl flag to cargo. (-vv) is
# also recommended for debugging purposes, as static linking and
# cross-compiling builds break easily in my experience.
# It is recommended to mount not only the work directory, but also the
# `~/.cargo/git` and `~/.cargo/registry` directories as it enables better caching.

# Example of using the built container to build Rust executables:
# (from command line in the project directory)
#
# docker run -it --rm \
#    -v $PWD:/workdir \
#    -v ~/.cargo/git:/root/.cargo/git \
#    -v ~/.cargo/registry:/root/.cargo/registry \
#    golddranks/rust_musl_docker:nightly-2017-08-21 \
#    cargo build --release -vv --target=x86_64-unknown-linux-musl



# Installing packages - WHY THESE PACKAGES?
# musl itself:
#   musl-dev, musl-tools
# optional utilities for debugging inside the container:
#   file - for inspecting built files (whether they are actually static)
#   nano - a text editor
#   git - because basically every Rust project uses it
#   zlib1g-dev, cmake, libssl-dev - needed for building cargo-tree which helps visualizing the build deps
#   libssl-dev - needed for dynamically linking (for diesel code generation) the libpq crate
# needed utilities for downloading, installing and building everything
# (diesel, rocket and their dependencies, mainly libpq and openssl):
#   curl, g++, make, pkgconf - these are needed by many libraries
#   linux-headers-amd64 - needed for building openssl 1.1
#   ca-certificates - for openssl & curl.
#   xutils-dev because it contains makedepend with is used by openssl build system
#   libpq-dev - needed for dynamically linking (for diesel code generation) the libpq crate

RUN apt-get update && \
  apt-get install -y \
  musl-dev \
  musl-tools \
  file \
  nano \
  git \
  zlib1g-dev \
  cmake \
  make \
  g++ \
  curl \
  pkgconf \
  linux-headers-amd64 \
  ca-certificates \
  xutils-dev \
  libpq-dev \
  libssl-dev \ 
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

# Setting the musl prefix where the statically linked C libs are installed
# Setting the workdir for building the C libs (we will later set another one for the Rust project)
ENV MUSL_PREFIX=/musl
RUN mkdir /workdir && mkdir $MUSL_PREFIX
WORKDIR /libworkdir

# OpenSSL 1.1 needs some linux headers to exists. They aren't installed by
# default to the directory of musl includes, so we must link them.
# OpenSSL 1.0 doesn't need these, but they won't do any harm.
RUN ln -s /usr/include/x86_64-linux-gnu/asm /usr/include/x86_64-linux-musl/asm && \
    ln -s /usr/include/asm-generic /usr/include/x86_64-linux-musl/asm-generic && \
    ln -s /usr/include/linux /usr/include/x86_64-linux-musl/linux

# Let's download the libraries so we don't have to do this everytime when
# debugging failing builds.
RUN curl -f -sL https://www.openssl.org/source/openssl-OPENSSL_VER.tar.gz | tar xz
RUN curl -f -sL https://ftp.postgresql.org/pub/source/vPOSTGRES_VER/postgresql-POSTGRES_VER.tar.gz | tar xz
RUN curl -f -sL https://zlib.net/zlib-1.2.11.tar.gz | tar xz

# Note that since Debian Stretch, gcc builds position-independent executables.
# The compilation will fail without flags "-fPIE" (which is for the compiler)
# and "-pie" (which is for the linker).

# The LDFLAGS and CFLAGS are set so that it finds the libraries we built earlier
# with the prefix /musl. (System musl libraries don't a have common prefix,
# they are found, for example in /usr/lib/x86_64-linux-musl, and includes in
# /usr/include/x86_64-linux-musl) This allows the libraries we build later
# to find the libraries we've built earlier. zlib doesn't depend on anything,
# but we'll set the flags for every one for consistency.
RUN cd zlib-1.2.11 && \
    CC="musl-gcc -fPIE -pie" LDFLAGS="-L/musl/lib/" CFLAGS="-I/musl/include" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$MUSL_PREFIX && \
    make -j$(nproc) && make install

# OpenSSL needs to be built with no-async because otherwise the build is going
# to crash with missing symbols. (Apparently it uses some stuff that musl doesn't have by default.)
# Note that OpenSSL has their own build system, they don't use autotools.
# This makes the settings a bit non-standard.
# Again, we use "-fPIE -pie" and set the flags.
RUN cd openssl-OPENSSL_VER && \
    CC="musl-gcc -fPIE -pie" LDFLAGS="-L/musl/lib/" CFLAGS="-I/musl/include" ./Configure no-shared no-async --prefix=$MUSL_PREFIX --openssldir=$MUSL_PREFIX/ssl linux-x86_64 && \
    make depend && make -j$(nproc) && make install

# Adding out library path to /etc/ld-musl-x86_64.path allows the dynamic linker
# to find musl libraries built by us. The configure script of postgres will
# fail without this, since it tests dynamic linking even if ne don't need it.
RUN echo "/musl/lib" >> /etc/ld-musl-x86_64.path

# Again, we use "-fPIE -pie" and set the flags.
# Readline is disabled, because we are too lazy to build musl-compatible one by ourselves.

RUN cd postgresql-POSTGRES_VER && \
    CC="musl-gcc -fPIE -pie" LDFLAGS="-L/musl/lib/" CFLAGS="-I/musl/include" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=$MUSL_PREFIX --host=x86_64-unknown-linux-musl --without-readline && \
    make -j$(nproc) && make install