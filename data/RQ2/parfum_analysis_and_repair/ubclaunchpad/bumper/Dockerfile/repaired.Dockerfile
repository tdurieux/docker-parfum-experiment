# Build server
FROM golang:alpine AS server
WORKDIR /app
ENV SRC_DIR=/go/src/github.com/ubclaunchpad/bumper/server
RUN apk add --update --no-cache git
ADD server $SRC_DIR
WORKDIR $SRC_DIR
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure --vendor-only
RUN go build -o server; cp server /app

# Copy build to final stage