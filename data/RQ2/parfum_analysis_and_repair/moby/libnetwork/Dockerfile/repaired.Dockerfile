ARG GO_VERSION=1.13.8

FROM golang:${GO_VERSION}-buster as dev
RUN apt-get update && apt-get -y --no-install-recommends install iptables \
		protobuf-compiler && rm -rf /var/lib/apt/lists/*;

RUN go get -d github.com/gogo/protobuf/protoc-gen-gogo && \
		cd /go/src/github.com/gogo/protobuf/protoc-gen-gogo && \
		git reset --hard 30cf7ac33676b5786e78c746683f0d4cd64fa75b && \
		go install

RUN go get golang.org/x/lint/golint \
		golang.org/x/tools/cmd/cover \
		github.com/mattn/goveralls \
		github.com/gordonklaus/ineffassign \
		github.com/client9/misspell/cmd/misspell

WORKDIR /go/src/github.com/docker/libnetwork

FROM dev

COPY . .
