FROM rust:1-alpine

RUN apk --no-cache add bash musl-dev openssl-dev shared-mime-info sudo protoc
RUN rustup component add rustfmt

ENTRYPOINT ["/bin/bash"]