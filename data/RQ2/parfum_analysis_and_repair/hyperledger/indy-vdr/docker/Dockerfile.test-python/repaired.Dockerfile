FROM rust:1.41-slim as builder

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    	build-essential cmake lcov && \
    rm -rf /var/lib/apt/lists/*

ADD libindy_vdr .
RUN --mount=type=cache,target=target \
    --mount=type=cache,target=/usr/local/cargo/registry \
    cargo build --lib $cargo_build_flags && \
    cp target/*/libindy_vdr.so .


## Start fresh (new image) ##
FROM debian:buster-slim


ARG uid=1001
ARG user=indy

ENV HOME="/home/$user" \
    APP_ROOT="$HOME" \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PIP_NO_CACHE_DIR=off \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    SHELL=/bin/bash

# Add indy user
RUN useradd -U -ms /bin/bash -u $uid $user

# Install environment
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        python3 python3-pip python3-setuptools && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc/*

WORKDIR $HOME

# Copy build results
COPY --from=builder --chown=indy:indy $HOME/.local .local

# - In order to drop the root user, we have to make some directories writable
#   to the root group as OpenShift default security model is to run the container
#   under random UID.
RUN usermod -a -G 0 indy

USER $user

# Create standard directories to allow volume mounting and set permissions
# Note: PIP_NO_CACHE_DIR environment variable should be cleared to allow caching
RUN mkdir -p \
        $HOME/.cache/pip/http \
        $HOME/config \
        $HOME/log && \
    chown -R indy:indy $HOME/.cache $HOME/config $HOME/log && \
    chmod -R ug+rw $HOME/.cache $HOME/config $HOME/log

COPY --chown=indy:indy wrappers/python/* wrapper/
COPY --from=builder /home/indy/libindy_vdr.so wrapper/indy_vdr/

RUN pip3 install --no-cache-dir -e wrapper

ENV RUST_LOG=${RUST_LOG:-debug}
ENV RUST_BACKTRACE=full

CMD python3 -m indy_vdr.test config/genesis.txn
