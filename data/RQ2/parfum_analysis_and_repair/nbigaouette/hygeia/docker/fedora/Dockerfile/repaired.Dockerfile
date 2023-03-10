ARG OS_NAME=fedora
ARG OS_VERSION=31

FROM ${OS_NAME}:${OS_VERSION} as builder

LABEL hygeia_${OS_NAME}_${OS_VERSION}_builder=true

ARG DOCKER_GID=792677
ARG DOCKER_UID=792677
ARG RUST_VERSION=1.51.0


ENV RUST_VERSION=${RUST_VERSION}
ENV RUST_LOG=hygeia=debug


# -------------------------------------------------------------------------------
# OS-specific
# SEE https://docs.fedoraproject.org/en-US/containers/guidelines/creation/
RUN dnf --setopt=tsflags=nodocs -y groupinstall "Development Tools" && \
    dnf --setopt=tsflags=nodocs -y install \
    vim \
    sudo \
    # To download rustup
    curl \
    # hygeia dependencies
    openssl-devel \
    && \
    dnf clean all
# -------------------------------------------------------------------------------


RUN groupadd --system hygeia --gid ${DOCKER_GID} && \
    useradd --create-home --system --gid hygeia --uid ${DOCKER_UID} hygeia && \
    chown hygeia:hygeia /home/hygeia
# Let user run sudo without password
RUN echo "hygeia ALL=(ALL) NOPASSWD:ALL" | EDITOR='tee -a' visudo

USER hygeia

WORKDIR /home/hygeia

# Install Rust (through rustup)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile=minimal --default-toolchain ${RUST_VERSION}
ENV PATH="/home/hygeia/.cargo/bin:${PATH}"


# -------------------------------------------------------------------------------
# Hygeia specific
# Copy a cache and extract
COPY --chown=hygeia:hygeia docker/${OS_NAME}/artifacts/docker_cargo_cache.tar.gz* Cargo.* ./
COPY --chown=hygeia:hygeia src ./src
COPY --chown=hygeia:hygeia tests ./tests
COPY --chown=hygeia:hygeia xtask ./xtask
COPY --chown=hygeia:hygeia hygeia_test_helpers ./hygeia_test_helpers
COPY --chown=hygeia:hygeia extra-packages-to-install.txt ./extra-packages-to-install.txt

RUN tar -zxf docker_cargo_cache.tar.gz || echo " ---> Cache file not found, skipping (please ignore tar error)." && rm docker_cargo_cache.tar.gz

RUN cargo build

# Create cache archive
RUN tar -zcf docker_cargo_cache.tar.gz .cargo target && rm docker_cargo_cache.tar.gz

RUN cargo run -- setup bash
# -------------------------------------------------------------------------------


# ########################################################################
FROM ${OS_NAME}:${OS_VERSION}

LABEL hygeia_${OS_NAME}_${OS_VERSION}_builder=false

ARG DOCKER_GID=792677
ARG DOCKER_UID=792677

# -------------------------------------------------------------------------------
# OS-specific
# Python build dependencies
# See https://devguide.python.org/setup/#linux
RUN dnf --setopt=tsflags=nodocs -y install dnf-plugins-core yum-utils sudo vim && \
    dnf --setopt=tsflags=nodocs -y builddep python3 && \
    dnf --setopt=tsflags=nodocs -y groupinstall "Development Tools"
# -------------------------------------------------------------------------------








RUN groupadd --system hygeia --gid ${DOCKER_GID} && \
    useradd --create-home --system --gid hygeia --uid ${DOCKER_UID} hygeia
# Let user run sudo without password
RUN echo "hygeia ALL=(ALL) NOPASSWD:ALL" | EDITOR='tee -a' visudo

USER hygeia

COPY --chown=hygeia:hygeia --from=builder /home/hygeia/.hygeia /home/hygeia/.hygeia
COPY --chown=hygeia:hygeia --from=builder /home/hygeia/.bashrc /home/hygeia/.bashrc
COPY --chown=hygeia:hygeia --from=builder /home/hygeia/docker_cargo_cache.tar.gz /home/hygeia/docker_cargo_cache.tar.gz

WORKDIR /home/hygeia

ENV PATH="/home/hygeia/.hygeia/shims:${PATH}"
