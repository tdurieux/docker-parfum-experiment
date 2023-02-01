# Golang build step / Debian Buster 21.01 / Golang 1.15.7
FROM golang:1.17.6@sha256:8fb6a244eeea71ca938a47eb046a39999a96ad43a0a69bf4275463df135bdc95 AS gobuilder
ARG version
ARG branch
ARG revision
COPY . /message-queue
WORKDIR /message-queue
RUN go install -v -ldflags="-X 'main.Branch=${branch}' -X 'main.Revision=${revision}' -X 'main.Version=${version}'" ./...

# Copy message-queue binary
FROM debian:stretch@sha256:4bb600434787c903886fe33526d19ff33114a33b433a4a4cdbdf9b8543f1ab5d
WORKDIR /app
COPY --from=gobuilder /go/bin/message-queue .
EXPOSE 8080
CMD ["./message-queue"]
