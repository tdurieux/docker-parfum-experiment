FROM golang:1.6

RUN apt-get update && apt-get install --no-install-recommends -y -q build-essential git && rm -rf /var/lib/apt/lists/*;

# golang puts its go install here (weird but true)
ENV GOROOT_BOOTSTRAP /usr/local/go

# golang sets GOPATH=/go
ADD . /go/src/tip
RUN go install tip
ENTRYPOINT ["/go/bin/tip"]
# Kubernetes expects us to listen on port 8080
EXPOSE 8080
