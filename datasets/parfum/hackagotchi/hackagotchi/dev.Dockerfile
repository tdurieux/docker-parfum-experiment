# Download reflex
FROM golang:1.15

RUN go get github.com/cespare/reflex

FROM rust:1.50

COPY --from=0 /go/bin/reflex /bin/reflex

WORKDIR /usr/src/app

COPY . .

RUN rustup toolchain install nightly

RUN cargo fetch

CMD ["reflex", "-r", ".(rs|json)$", "-R", "target/", "-s", "--", "rustup", "run", "nightly", "cargo", "run"]
