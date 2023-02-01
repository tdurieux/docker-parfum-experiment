# stage 1: build
FROM golang:1.10 as builder
LABEL stage=intermediate

ARG dregsy_version

COPY . $GOPATH/src/github.com/xelalexv/dregsy/
WORKDIR $GOPATH/src/github.com/xelalexv/dregsy/

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -a \
	-tags netgo -installsuffix netgo \
	-ldflags "-w -X main.DregsyVersion=${dregsy_version}" \
	-o /go/bin/dregsy ./cmd/dregsy/

# stage 2: create actual dregsy container
FROM scratch

# also get CA certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY ./third_party/skopeo/skopeo /
COPY --from=builder /go/bin/dregsy /

ENV PATH=/
CMD ["/dregsy", "-config=config.yaml"]
