# Dockerfile for building the wallet server. To build the image, run the
# following command from the traffic-director-grpc-examples directory:
# docker build -t <TAG> -f go/wallet_server/Dockerfile .

FROM golang:1.16-alpine as build

# Make a traffic-director-grpc-examples directory and copy the repo into it.
WORKDIR /traffic-director-grpc-examples
COPY . .

# Build a static binary without cgo so that we can copy just the binary in the
# final image, and can get rid of the Go compiler and other dependencies.
WORKDIR go/wallet_server
RUN go build -o wallet_server -tags osusergo,netgo main.go

# Second stage of the build which copies over only the server binary and skips
# the Go compiler and traffic-director-grpc-examples repo from the earlier
# stage. This significantly reduces the docker image size.