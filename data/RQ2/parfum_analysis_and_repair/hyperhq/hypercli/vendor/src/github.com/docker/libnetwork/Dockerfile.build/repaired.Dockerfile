FROM golang:1.4-cross
RUN apt-get update && apt-get -y --no-install-recommends install iptables && rm -rf /var/lib/apt/lists/*;

RUN cd /go/src && mkdir -p golang.org/x && \
    cd golang.org/x && git clone https://github.com/golang/tools && \
    cd tools && git checkout release-branch.go1.5

RUN go get github.com/tools/godep \
		github.com/golang/lint/golint \
		golang.org/x/tools/cmd/vet \
		golang.org/x/tools/cmd/goimports \
		golang.org/x/tools/cmd/cover\
		github.com/mattn/goveralls
