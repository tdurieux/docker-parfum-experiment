FROM sovrin/dockerbase:base-centos7-0.3.0
# TODO LABEL maintainer="Name <email-address>"

ARG RUST_VERSION

ENV RUST_VERSION=${RUST_VERSION:-1.26.0}
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --default-toolchain $RUST_VERSION \
    && chmod -R a+w $RUSTUP_HOME $CARGO_HOME \
    && rustup --version \
    && cargo --version \
    && rustc --version

# TODO CMD ENTRYPOINT ...

ENV RUST_ENV_VERSION=0.5.0