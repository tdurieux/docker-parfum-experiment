# source: https://github.com/peter-evans/knative-docs/blob/master/serving/samples/helloworld-go/Dockerfile
# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang

# Copy the local package files to the container's workspace.
ADD src src

# Build sample.
RUN go install ./src/go/helloworld

# Run the command by default when the container starts.
ENTRYPOINT /go/bin/helloworld

# Document that the service listens on port 8080.