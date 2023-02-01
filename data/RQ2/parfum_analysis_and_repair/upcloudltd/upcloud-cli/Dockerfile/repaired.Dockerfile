FROM golang:1.18-buster as builder
RUN apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/upctl/
COPY . .
RUN make build-dockerised

FROM scratch
LABEL org.label-schema.vcs-url="https://github.com/UpCloudLtd/upcloud-cli"
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/upctl/bin/*dockerised-linux-amd64 /upctl

ENTRYPOINT ["/upctl"]
