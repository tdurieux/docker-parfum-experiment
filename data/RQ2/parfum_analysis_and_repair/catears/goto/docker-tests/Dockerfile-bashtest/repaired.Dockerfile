FROM rust as builder

WORKDIR /build
COPY src src/
COPY Cargo.toml Cargo.toml ./
RUN cargo build --release

FROM ubuntu:18.04 as runner
WORKDIR /run
COPY --from=builder /build/target/ /build/target
RUN ln -s /build/target/release/goto-cd /usr/bin/goto-cd
COPY tests tests/

ENV RCFILE="/root/.bashrc"

CMD ["bash", "tests/test_shell.sh"]