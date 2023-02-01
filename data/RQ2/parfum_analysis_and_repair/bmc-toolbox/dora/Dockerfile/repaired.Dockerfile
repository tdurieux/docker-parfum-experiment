# Build
FROM golang:1 as build

WORKDIR /build
ADD . .

# Tests
# TODO enable after fixing code for tests too pass
#RUN go test -tags="gingonic" -mod=vendor ./...

RUN GOOS=linux go build -mod=vendor -ldflags '-extldflags "-static"' -tags="gingonic netgo osusergo" -a -installsuffix cgo -o dora .

# Run