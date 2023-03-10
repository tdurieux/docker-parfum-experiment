ARG BUILDER_DIR=/srv/mycitadel


FROM rust:1.47.0-slim-buster as builder

ARG SRC_DIR=/usr/local/src/mycitadel
ARG BUILDER_DIR

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        libsqlite3-dev \
        libssl-dev \
        libzmq3-dev \
        pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR "$SRC_DIR"

COPY doc ${SRC_DIR}/doc
COPY shell ${SRC_DIR}/shell
COPY src ${SRC_DIR}/src
COPY build.rs Cargo.lock Cargo.toml codecov.yml config_spec.toml \
     LICENSE license_header.txt README.md ${SRC_DIR}/

WORKDIR ${SRC_DIR}

RUN mkdir "${BUILDER_DIR}"

RUN cargo install --path . --root "${BUILDER_DIR}" --bins --all-features


FROM debian:buster-slim

ARG BUILDER_DIR
ARG BIN_DIR=/usr/local/bin
ARG DATA_DIR=/var/lib/mycitadel
ARG USER=mycitadeld

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        libzmq3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN adduser --home "${DATA_DIR}" --shell /bin/bash --disabled-login \
        --gecos "${USER} user" ${USER}

COPY --from=builder --chown=${USER}:${USER} \
     "${BUILDER_DIR}/bin/" "${BIN_DIR}"

WORKDIR "${BIN_DIR}"
USER ${USER}

VOLUME "$DATA_DIR"

EXPOSE 9735

ENTRYPOINT ["mycitadeld"]

CMD ["-vvv", "--data-dir", "/var/lib/mycitadel"]
