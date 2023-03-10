FROM quay.io/pypa/manylinux2010_x86_64:latest

COPY --from=rust:1.41.0-slim /usr/local/cargo /usr/local/cargo
COPY --from=rust:1.41.0-slim /usr/local/rustup /usr/local/rustup

ENV PATH=$PATH:/usr/local/cargo/bin
ENV CARGO_HOME=/usr/local/cargo
ENV RUSTUP_HOME=/usr/local/rustup
RUN chmod a+w /usr/local/cargo