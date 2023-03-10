FROM clux/muslrust as builder

ADD . /didkit
ADD ./ssi /ssi
WORKDIR /didkit/http

RUN cargo build --release

FROM alpine
COPY --from=builder /didkit/target/x86_64-unknown-linux-musl/release/didkit-http /usr/local/bin/

ENTRYPOINT ["didkit-http"]