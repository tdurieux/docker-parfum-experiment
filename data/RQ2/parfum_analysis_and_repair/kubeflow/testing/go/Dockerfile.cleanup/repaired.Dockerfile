ARG GOLANG_VERSION=1.14
FROM golang:${GOLANG_VERSION} as builder

WORKDIR /workspace

COPY . /workspace

# Predownload modules
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go mod download
# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o cleanup cmd/cleanup/main.go

FROM gcr.io/distroless/base
COPY --from=builder /workspace/cleanup /
COPY ./cmd/cleanup/configs /configs
ENTRYPOINT [ "/cleanup", "apply", "-f" ]
CMD ["/configs/cleanup_pipelineruns_kf_releasing.yaml"]