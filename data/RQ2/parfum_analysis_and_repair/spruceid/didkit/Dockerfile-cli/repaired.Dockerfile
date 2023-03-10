FROM clux/muslrust as builder

ADD . /didkit
ADD ./ssi /ssi
WORKDIR /didkit/cli

RUN cargo build --release

FROM alpine
COPY --from=builder /didkit/target/x86_64-unknown-linux-musl/release/didkit didkit
ENTRYPOINT ["./didkit"]