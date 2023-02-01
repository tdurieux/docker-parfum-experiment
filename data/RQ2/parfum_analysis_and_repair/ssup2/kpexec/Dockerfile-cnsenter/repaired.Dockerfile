FROM golang:1.16 as builder
WORKDIR /workspace

# Build cnsenter
ARG VERSION
COPY . .
RUN CGO_ENABLED=0 GO111MODULE=on go build -a -ldflags="-X 'github.com/ssup2/kpexec/pkg/cmd/cnsenter.version=${VERSION}'" -o cnsenter cmd/cnsenter/main.go

# Build image
FROM alpine:3.13.1
COPY --from=builder /workspace/cnsenter /usr/bin/cnsenter

CMD ["cnsenter"]