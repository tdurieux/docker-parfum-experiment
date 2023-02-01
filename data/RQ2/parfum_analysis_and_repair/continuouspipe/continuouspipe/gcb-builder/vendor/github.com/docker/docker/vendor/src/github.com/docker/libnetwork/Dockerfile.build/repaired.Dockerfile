FROM golang:1.7.1
RUN apt-get update && apt-get -y --no-install-recommends install iptables && rm -rf /var/lib/apt/lists/*;

RUN go get github.com/tools/godep \
		github.com/golang/lint/golint \
		golang.org/x/tools/cmd/cover\
		github.com/mattn/goveralls
