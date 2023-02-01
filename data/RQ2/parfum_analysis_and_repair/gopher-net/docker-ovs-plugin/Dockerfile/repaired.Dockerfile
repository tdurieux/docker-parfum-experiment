FROM golang
RUN apt-get update && apt-get -y --no-install-recommends install iptables dbus && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/tools/godep
COPY . /go/src/github.com/gopher-net/docker-ovs-plugin
WORKDIR /go/src/github.com/gopher-net/docker-ovs-plugin
RUN godep go install -v
ENTRYPOINT ["docker-ovs-plugin"]
