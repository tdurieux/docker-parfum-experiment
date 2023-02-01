FROM golang:1.14 as builder
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        gcc gcc-mingw-w64 gcc-multilib \
        git make \
        musl-dev liblzma-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /go/src/github.com/mendersoftware/mender-artifact
WORKDIR /go/src/github.com/mendersoftware/mender-artifact
ADD ./ .
RUN make build-natives

FROM alpine:3.16.0
RUN apk add --no-cache xz-dev
COPY --from=builder /go/src/github.com/mendersoftware/mender-artifact/mender-artifact* /go/bin/
ENTRYPOINT [ "/go/bin/mender-artifact-linux" ]
