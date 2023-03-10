# How to build and run this Dockerfile:
#
# ```
# RUST_FIL_PROOFS=`pwd` # path to `rust-fil-proofs`
# docker --log-level debug build --progress tty --file Dockerfile-profile --tag rust-cpu-profile .
# docker run -it -v $RUST_FIL_PROOFS:/code/ rust-cpu-profile
# ```

FROM rust

# Get all the dependencies
# ------------------------

# Copied from: github.com/filecoin-project/rust-fil-proofs/blob/master/Dockerfile-ci
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl file gcc g++ git make openssh-client \
    autoconf automake cmake libtool libcurl4-openssl-dev libssl-dev \
    libelf-dev libdw-dev binutils-dev zlib1g-dev libiberty-dev wget \
    xz-utils pkg-config python clang && rm -rf /var/lib/apt/lists/*;

# `gperftools` and dependencies (`libunwind`)
# -------------------------------------------

ENV GPERFTOOLS_VERSION="2.7"
ENV LIBUNWIND_VERSION="0.99-beta"

ENV HOME="/root"
ENV DOWNLOADS=${HOME}/downloads
RUN mkdir -p ${DOWNLOADS}
RUN echo ${DOWNLOADS}
WORKDIR ${DOWNLOADS}

RUN wget https://download.savannah.gnu.org/releases/libunwind/libunwind-${LIBUNWIND_VERSION}.tar.gz --output-document ${DOWNLOADS}/libunwind-${LIBUNWIND_VERSION}.tar.gz
RUN tar -xvf ${DOWNLOADS}/libunwind-${LIBUNWIND_VERSION}.tar.gz && rm ${DOWNLOADS}/libunwind-${LIBUNWIND_VERSION}.tar.gz
WORKDIR ${DOWNLOADS}/libunwind-${LIBUNWIND_VERSION}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make
RUN make install
WORKDIR ${DOWNLOADS}

RUN wget https://github.com/gperftools/gperftools/releases/download/gperftools-${GPERFTOOLS_VERSION}/gperftools-${GPERFTOOLS_VERSION}.tar.gz  --output-document ${DOWNLOADS}/gperftools-${GPERFTOOLS_VERSION}.tar.gz
RUN tar -xvf ${DOWNLOADS}/gperftools-${GPERFTOOLS_VERSION}.tar.gz && rm ${DOWNLOADS}/gperftools-${GPERFTOOLS_VERSION}.tar.gz
WORKDIR ${DOWNLOADS}/gperftools-${GPERFTOOLS_VERSION}
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make install
WORKDIR ${DOWNLOADS}

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
# FIXME: `gperftools` installs the library (`make install`) in
# `/usr/local/lib` by default but Debian/Ubuntu don't look there
# now, the correct `--prefix` should be added to the command.

# Install latest toolchain used by `rust-fil-proofs`
# --------------------------------------------------

RUN rustup default nightly-2019-07-15
# FIXME: The lastest version used should be dynamically obtained form the `rust-fil-proofs` repo
# and not hard-coded here.

# Ready to run
# ------------

WORKDIR /code

CMD                                                                           \
cargo update                                                                  \
&&                                                                            \
cargo build                                                                   \
  -p filecoin-proofs                                                          \
  --release                                                                   \
  --example stacked                                                            \
  --features                                                                  \
    cpu-profile                                                               \
  -Z package-features                                                         \
&&                                                                            \
RUST_BACKTRACE=full                                                           \
RUST_LOG=trace                                                                \
target/release/examples/stacked                                                \
  --size 1024                                                                 \
&&                                                                            \
pprof target/release/examples/stacked replicate.profile || bash
